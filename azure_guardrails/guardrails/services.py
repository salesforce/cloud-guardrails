import os
import json
import csv
import logging
from operator import itemgetter
from azure_guardrails.shared import utils
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config
from azure_guardrails.guardrails.policy_definition import PolicyDefinition

logger = logging.getLogger(__name__)


class Service:
    def __init__(self, service_name: str, config: Config = DEFAULT_CONFIG):
        self.service_name = service_name
        self.config = config
        service_policy_directory = os.path.join(
            utils.AZURE_POLICY_SERVICE_DIRECTORY, self.service_name
        )
        self.policy_files = self._policy_files(service_policy_directory)
        self.policy_definitions = self._policy_definitions()

    def __repr__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            service_name=self.service_name,
        )

        if self.policy_definitions:
            policy_definitions_result = {}
            for (
                policy_definition,
                policy_definition_details,
            ) in self.policy_definitions.items():
                policy_definitions_result[
                    policy_definition
                ] = policy_definition_details.json()
            result["policy_definitions"] = policy_definitions_result
        return result

    @staticmethod
    def _policy_files(service_policy_directory: str) -> list:
        policy_files = [
            f
            for f in os.listdir(service_policy_directory)
            if os.path.isfile(os.path.join(service_policy_directory, f))
        ]
        policy_files.sort()
        return policy_files

    def _policy_definitions(self) -> dict:
        policy_definitions = {}
        for file in self.policy_files:
            policy_content = utils.get_policy_json(
                service_name=self.service_name, filename=file
            )
            policy_definition = PolicyDefinition(
                policy_content=policy_content, service_name=self.service_name
            )
            policy_definitions[policy_definition.display_name] = policy_definition
        return policy_definitions

    def skip_display_names(self, policy_definition: PolicyDefinition) -> bool:
        # Quality control
        # First, if the display name starts with [Deprecated], skip it
        if policy_definition.display_name.startswith("[Deprecated]: "):
            logger.debug(
                "Skipping Policy (Deprecated). Policy name: %s"
                % policy_definition.display_name
            )
            return True
        # Some Policies with Modify capabilities don't have an Effect - only way to detect them is to see if the name starts with 'Deploy'
        elif policy_definition.display_name.startswith("Deploy "):
            logger.debug(
                "Skipping Policy (Deploy). Policy name: %s"
                % policy_definition.display_name
            )
            return True
        # If the policy is deprecated, skip it
        elif policy_definition.is_deprecated:
            logger.debug(
                "Skipping Policy (Deprecated). Policy name: %s"
                % policy_definition.display_name
            )
            return True
        # If we have specified it in the Config config, skip it
        elif self.config.is_excluded(
            service_name=self.service_name, display_name=policy_definition.display_name
        ):
            logger.debug(
                "Skipping Policy (Excluded by user). Policy name: %s"
                % policy_definition.display_name
            )
            return True
        else:
            return False

    @property
    def display_names(self) -> list:
        display_names = list(self.policy_definitions.keys())
        display_names.sort()
        return display_names

    @property
    def display_names_no_params(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.no_params:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    @property
    def display_names_params_optional(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.params_optional:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    @property
    def display_names_params_required(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.params_required:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    def get_policy_definition_parameters(
        self, display_name: str, params_required: bool = False
    ) -> dict:
        parameters = {}
        for this_display_name, policy_definition in self.policy_definitions.items():
            if this_display_name == display_name:
                # Params required
                if params_required and policy_definition.params_required:
                    for (
                        parameter_name,
                        parameter_details,
                    ) in policy_definition.parameters.items():
                        if parameter_details.name == "effect":
                            continue
                        parameters[parameter_details.name] = parameter_details.json()
                    continue
                # Params Optional
                if not params_required and policy_definition.params_optional:
                    for (
                        parameter_name,
                        parameter_details,
                    ) in policy_definition.parameters.items():
                        if parameter_details.name == "effect":
                            continue
                        parameters[parameter_details.name] = parameter_details.json()
                    continue
        return parameters


class Services:
    default_service_names = utils.get_service_names()
    default_service_names.sort()

    def __init__(
        self,
        service_names: list = default_service_names,
        config: Config = DEFAULT_CONFIG,
    ):
        if service_names == ["all"]:
            service_names = utils.get_service_names()
            service_names.sort()
        self.service_names = service_names
        self.config = config
        self.services = self._services()

    def _services(self) -> dict:
        services = {}
        service_names = self.service_names
        for service_name in service_names:
            service = Service(service_name=service_name, config=self.config)
            services[service_name] = service
        return services

    def get_policy_definition(self, display_name) -> PolicyDefinition:
        definitions_found = []
        policy_definition = None
        for service_name, service_details in self.services.items():
            if service_details.policy_definitions.get(display_name, None):
                definitions_found.append(f"{service_name}: {display_name}")
                policy_definition = service_details.policy_definitions[display_name]
                break
        return policy_definition

    @property
    def display_names_no_params(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_no_params)
        display_names.sort()
        return display_names

    @property
    def display_names_params_optional(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_params_optional)
        display_names.sort()
        return display_names

    @property
    def display_names_params_required(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_params_required)
        display_names.sort()
        return display_names

    def get_display_names_sorted_by_service_no_params(self) -> dict:
        results = {}
        for service_name, service_details in self.services.items():
            logger.debug("Getting display names for service: %s" % service_name)
            this_service_display_names = service_details.display_names_no_params
            this_service_display_names = list(
                dict.fromkeys(this_service_display_names)
            )  # remove duplicates
            if this_service_display_names:
                results[service_name] = this_service_display_names
        return results

    def get_display_names_sorted_by_service_with_params(
        self, params_required: bool = False
    ) -> dict:
        results = {}
        for service_name, service_details in self.services.items():
            logger.debug("Getting display names for service: %s" % service_name)
            service_parameters = {}

            # Get the display names depending on whether we are looking for Params Required or Params Optional
            if params_required:
                this_service_display_names = (
                    service_details.display_names_params_required
                )
            else:
                this_service_display_names = (
                    service_details.display_names_params_optional
                )

            # Loop through the service's display names and get the parameters for each Policy Definition
            for display_name in this_service_display_names:
                parameters = service_details.get_policy_definition_parameters(
                    display_name=display_name, params_required=params_required
                )
                if parameters:
                    service_parameters[display_name] = parameters
            results[service_name] = service_parameters
        return results

    def get_all_display_names_sorted_by_service(self) -> dict:
        results = {}
        for service_name, service_details in self.services.items():
            service_results = []
            service_results.extend(service_details.display_names_no_params)
            service_results.extend(service_details.display_names_params_optional)
            service_results.extend(service_details.display_names_params_required)
            service_results.sort()
            service_results = list(dict.fromkeys(service_results))  # remove duplicates
            if service_results:
                results[service_name] = service_results
        return results

    def compliance_coverage_data(self) -> dict:
        results = {}
        compliance_data_file = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__), os.path.pardir, "shared", "data", "compliance-data.json"
            )
        )
        with open(compliance_data_file) as json_file:
            compliance_data = json.load(json_file)
        display_names_sorted = self.get_all_display_names_sorted_by_service()
        for service_name, display_names in display_names_sorted.items():
            for display_name in display_names:
                policy_definition_compliance_metadata = compliance_data.get(display_name, None)
                if not policy_definition_compliance_metadata:
                    continue
                service_results = {}
                # if it exists in the display names
                if policy_definition_compliance_metadata:
                    policy_def_results = dict(
                        description=policy_definition_compliance_metadata.get("description"),
                        effects=policy_definition_compliance_metadata.get("effects").lower(),
                        github_link=policy_definition_compliance_metadata.get("github_link"),
                        github_version=policy_definition_compliance_metadata.get("github_version"),
                        name=display_name,
                        policy_id=policy_definition_compliance_metadata.get("policy_id"),
                        service_name=policy_definition_compliance_metadata.get("service_name"),
                        benchmarks=policy_definition_compliance_metadata.get("benchmarks"),
                    )
                # otherwise, gather the data from self
                else:
                    policy_definition = self.get_policy_definition(display_name)
                    if not policy_definition:
                        raise Exception(f"Policy definition with display name {display_name} not found")
                    policy_def_results = dict(
                        description=policy_definition.properties.description,
                        effects=','.join(policy_definition.allowed_effects),
                        github_link=None,
                        github_version=None,
                        name=display_name,
                        policy_id=policy_definition.id,
                        service_name=service_name,
                        benchmarks={},
                    )
                service_results[display_name] = policy_def_results
                if not results.get(service_name):
                    results[service_name] = service_results
                else:
                    results[service_name][display_name] = policy_def_results
        return results

    def table_summary(self, hyperlink_format: bool = True) -> list:
        results = []

        def get_benchmark_id(benchmark_name: str, this_policy_metadata: dict) -> str:
            if this_policy_metadata["benchmarks"].get(benchmark_name, None):
                benchmark_id = this_policy_metadata["benchmarks"][benchmark_name]["requirement_id"]
                benchmark_id = benchmark_id.replace(f"{benchmark_name}: ", "")
                benchmark_id = benchmark_id.replace(f"ID : ", "")
            else:
                benchmark_id = ""
            return benchmark_id

        compliance_coverage_data = self.compliance_coverage_data()
        for service_name, service_details in compliance_coverage_data.items():
            for display_name, policy_metadata in service_details.items():
                name = display_name.replace("[Preview]: ", "")
                # benchmarks = []
                github_link = ""
                policy_definition_obj = self.get_policy_definition(display_name)

                # Get the string that we'll put in the name, depending on if we want to use Markdown hyperlink format or just the name itself
                if hyperlink_format:
                    if github_link != "":
                        policy_definition_string = f"[{name}]({github_link})"
                    else:
                        policy_definition_string = name
                else:
                    policy_definition_string = name

                azure_security_benchmark_id = get_benchmark_id(
                    "Azure Security Benchmark", policy_metadata
                )
                cis_id = get_benchmark_id("CIS", policy_metadata)
                ccmc_id = get_benchmark_id("CCMC L3", policy_metadata)
                iso_id = get_benchmark_id("ISO 27001", policy_metadata)
                nist_800_171_id = get_benchmark_id(
                    "NIST SP 800-171 R2", policy_metadata
                )
                nist_800_53_id = get_benchmark_id(
                    "NIST SP 800-53 R4", policy_metadata
                )
                hipaa_id = get_benchmark_id("HIPAA HITRUST 9.2", policy_metadata)
                new_zealand_id = get_benchmark_id(
                    "NZISM Security Benchmark", policy_metadata
                )
                parameter_requirements = None
                if policy_definition_obj.no_params:
                    parameter_requirements = "None"
                elif policy_definition_obj.params_optional:
                    parameter_requirements = "Optional"
                elif policy_definition_obj.params_required:
                    parameter_requirements = "Required"

                parameter_names = policy_definition_obj.parameter_names
                if "effect" in parameter_names:
                    parameter_names.remove("effect")
                parameter_names = ", ".join(parameter_names)
                result = {
                    "Service": service_name,
                    "Policy Definition": policy_definition_string,
                    "Parameter Requirements": parameter_requirements,
                    "Parameters": parameter_names,
                    # "Name": policy_definition_name,
                    "Azure Security Benchmark": azure_security_benchmark_id,
                    "CIS": cis_id,
                    "CCMC L3": ccmc_id,
                    "ISO 27001": iso_id,
                    "NIST SP 800-171 R2": nist_800_171_id,
                    "NIST SP 800-53 R4": nist_800_53_id,
                    "HIPAA HITRUST 9.2": hipaa_id,
                    "New Zealand ISM": new_zealand_id,
                    "Link": github_link,
                }
                results.append(result)
        results = sorted(results, key=itemgetter("Service", "Policy Definition"))
        return results

    def csv_summary(self, path: str, verbosity: int):
        headers = [
            "Service",
            "Policy Definition",
            "Parameter Requirements",
            "Parameters",
            "Azure Security Benchmark",
            "CIS",
            "CCMC L3",
            "ISO 27001",
            "NIST SP 800-53 R4",
            "NIST SP 800-171 R2",
            "HIPAA HITRUST 9.2",
            "New Zealand ISM",
            "Link",
        ]

        # results = headers.copy()
        results = self.table_summary(hyperlink_format=False)
        if os.path.exists(path):
            os.remove(path)
            if verbosity >= 1:
                utils.print_grey(f"Removing the previous file: {path}")
        with open(path, "w", newline="") as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=headers)
            writer.writeheader()
            for row in results:
                writer.writerow(row)

