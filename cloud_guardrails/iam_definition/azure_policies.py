# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""
Single data source for the Policy Definition. It combines the azure-policy GitHub module into a single JSON file
"""
import os
import json
from tabulate import tabulate
from operator import itemgetter
import csv
from collections import OrderedDict
import logging
from cloud_guardrails.shared import utils
from cloud_guardrails.shared.config import DEFAULT_CONFIG, Config
from cloud_guardrails.iam_definition.policy_definition import PolicyDefinition

logger = logging.getLogger(__name__)

default_service_names = utils.get_service_names()
default_service_names.sort()

iam_definition_path = os.path.join(utils.DATA_FILE_DIRECTORY, "iam-definition.json")
with open(iam_definition_path, "r") as file:
    iam_definition = json.load(file)


def skip_display_names(policy_definition: PolicyDefinition, config: Config = DEFAULT_CONFIG) -> bool:
    # Quality control
    # First, if the display name starts with [Deprecated], skip it
    if policy_definition.display_name.startswith("[Deprecated]: "):
        logger.debug(
            "Skipping Policy (Deprecated). Policy name: %s"
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
    elif policy_definition.modifies_resources:
        logger.info(f"Skipping Policy (Modify). Policy name: {policy_definition.display_name} with effects: {policy_definition.allowed_effects}")
        return True
    # Some Policies with Modify capabilities don't have an Effect - only way to detect them is to see if the name starts with 'Deploy'
    elif policy_definition.display_name.startswith("Deploy "):
        logger.info(f"Skipping Policy (Deploy). Policy name: {policy_definition.display_name} with effects: {policy_definition.allowed_effects}")
        return True
    # If we have specified it in the Config config, skip it
    elif config.is_excluded(
            service_name=policy_definition.service_name, display_name=policy_definition.display_name
    ):
        logger.info(
            "Skipping Policy (Excluded by user). Policy name: %s"
            % policy_definition.display_name
        )
        return True
    else:
        # print(f"Allowing policy with effects {policy_definition.allowed_effects} and name {policy_definition.display_name}")
        return False


class AzurePolicies:
    def __init__(
            self,
            service_names: list = default_service_names,
            config: Config = DEFAULT_CONFIG,
    ):
        self.config = config
        self.service_names = self.set_service_names(service_names=service_names)
        self.service_definitions = iam_definition["service_definitions"]
        self.policy_definitions = iam_definition["policy_definitions"]

    def set_service_names(self, service_names: list):
        if service_names == ["all"]:
            service_names = utils.get_service_names()
            service_names.sort()
        service_names_to_remove = []
        for service_name in service_names:
            if self.config.is_service_excluded(service_name=service_name):
                service_names_to_remove.append(service_name)
        for service_name in service_names_to_remove:
            service_names.remove(service_name)
        return service_names

    def policy_ids(self, service_name: str = None) -> list:
        results = []
        if service_name:
            results = list(self.service_definitions.get(service_name).keys())
        else:
            for service in self.service_names:
                results.extend(list(self.service_definitions.get(service).keys()))
        # results.sort()
        return results

    def lookup(self, policy_id: str, policy_property: str):
        """Looks up a policy property given a policy ID and optionally a service name"""
        result = None
        try:
            result = self.policy_definitions.get(policy_id).get(policy_property)
        except KeyError as error:
            logger.warning(error)
        return result

    def get_policy_definition(self, policy_id: str) -> PolicyDefinition:
        service_name = self.policy_definitions.get(policy_id).get("service_name")
        policy_content = self.policy_definitions.get(policy_id).get("policy_content")
        file_name = self.policy_definitions.get(policy_id).get("file_name")
        policy_definition = PolicyDefinition(policy_content=policy_content, service_name=service_name,
                                             file_name=file_name)
        return policy_definition

    def get_policy_definition_by_display_name(self, display_name: str) -> PolicyDefinition:
        policy_definition = None
        for policy_id, policy_details in self.policy_definitions.items():
            if policy_details.get("display_name") == display_name:
                policy_definition = self.get_policy_definition(policy_id=policy_id)
                break
        return policy_definition

    def get_policy_id_by_display_name(self, display_name: str) -> str:
        policy_definition = self.get_policy_definition_by_display_name(display_name=display_name)
        return policy_definition.short_id

    def get_parameters_by_policy_id(self, policy_id: str, include_effect: bool = False) -> dict:
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        parameters = {}
        for parameter_name, parameter_details in policy_definition.parameters.items():
            if not include_effect:
                if parameter_details.name == "effect":
                    continue
            parameters[parameter_details.name] = parameter_details.json()
        return parameters

    def get_allowed_values_for_parameter(self, policy_id: str, parameter_name: str):
        """Given a policy ID and a parameter name, get the allowed_values for a parameter"""
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        try:
            parameter = policy_definition.properties.parameters.get(parameter_name)
            if isinstance(parameter.allowed_values, type(None)):
                return None
            elif isinstance(parameter.allowed_values, list):
                return parameter.allowed_values
            else:
                return []
        except Exception as error:
            logger.debug(error)
            return None

    def get_default_value_for_parameter(self, policy_id: str, parameter_name: str):
        """Given a policy ID and a parameter name, get the allowed_values for a parameter"""
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        try:
            parameter = policy_definition.properties.parameters.get(parameter_name)
            if isinstance(parameter.default_value, type(None)):
                return None
            elif (
                isinstance(parameter.default_value, list)
                or isinstance(parameter.default_value, dict)
                or isinstance(parameter.default_value, bool)
                or isinstance(parameter.default_value, int)
                or isinstance(parameter.default_value, str)
            ):
                return parameter.default_value
        except Exception as error:
            logger.debug(error)
            return []

    def get_parameter_type(self, policy_id: str, parameter_name: str):
        """Given a policy ID and a parameter name, get the type of a parameter"""
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        parameter = policy_definition.properties.parameters.get(parameter_name, None)
        return parameter.type

    def get_required_parameters(self, policy_id: str) -> list:
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        parameters = policy_definition.get_required_parameters()
        return parameters

    def get_optional_parameters(self, policy_id: str) -> list:
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        parameters = policy_definition.get_optional_parameters()
        return parameters

    def is_policy_id_excluded(self, policy_id: str) -> bool:
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        # Quality control
        # First, if the display name starts with [Deprecated], skip it
        if policy_definition.display_name.startswith("[Deprecated]: "):
            logger.debug(
                "Skipping Policy (Deprecated). Policy name: %s"
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
        elif policy_definition.modifies_resources:
            logger.info(
                f"Skipping Policy (Modify). Policy name: {policy_definition.display_name} with effects: {policy_definition.allowed_effects}")
            return True
        # Some Policies with Modify capabilities don't have an Effect - only way to detect them is to see if the name starts with 'Deploy'
        elif policy_definition.display_name.startswith("Deploy "):
            logger.info(
                f"Skipping Policy (Deploy). Policy name: {policy_definition.display_name} with effects: {policy_definition.allowed_effects}")
            return True
        # If we have specified it in the Config config, skip it
        elif self.config.is_excluded(
                service_name=policy_definition.service_name, display_name=policy_definition.display_name
        ):
            logger.info(
                "Skipping Policy (Excluded by user). Policy name: %s"
                % policy_definition.display_name
            )
            return True
        else:
            # print(f"Allowing policy with effects {policy_definition.allowed_effects} and name {policy_definition.display_name}")
            return False

    def display_names(self, service_name: str = None) -> list:
        results = []
        if service_name:
            for policy_id, policy_details in self.service_definitions.get(service_name).items():
                if not self.is_policy_id_excluded(policy_id=policy_id):
                    results.append(policy_details.get("display_name"))
        else:
            for service in self.service_names:
                for policy_id, policy_details in self.service_definitions.get(service).items():
                    if not self.is_policy_id_excluded(policy_id=policy_id):
                        results.append(policy_details.get("display_name"))
        results.sort()
        return results

    def get_all_display_names_sorted_by_service(self, no_params: bool = True, params_optional: bool = True,
                                                params_required: bool = True, audit_only: bool = False) -> dict:
        results = {}
        for service_name, service_policies in self.service_definitions.items():
            service_results = []
            for policy_id, policy_details in service_policies.items():
                if not self.is_policy_id_excluded(policy_id=policy_id):
                    if no_params:
                        if policy_details.get("no_params"):
                            service_results.append(policy_details.get("display_name"))
                    if params_optional:
                        if policy_details.get("params_optional"):
                            service_results.append(policy_details.get("display_name"))
                    if params_required:
                        if policy_details.get("params_required"):
                            service_results.append(policy_details.get("display_name"))
                    # If audit_only is flagged, create a new list to hold the audit-only ones, then save it as the new service results
                    if audit_only:
                        filtered_service_results = []
                        for service_result in service_results:
                            if policy_details.get("audit_only"):
                                filtered_service_results.append(service_result)
                        service_results = filtered_service_results.copy()
                    # If audit_only is not used, don't worry about it
                    service_results.sort()
                    service_results = list(dict.fromkeys(service_results))  # remove duplicates
                    if service_results:
                        results[service_name] = service_results
        return results

    def get_all_policy_ids_sorted_by_service(self, no_params: bool = True, params_optional: bool = True,
                                             params_required: bool = True, audit_only: bool = False) -> dict:

        results = {}
        for service_name, service_policies in self.service_definitions.items():
            if self.config.is_service_excluded(service_name=service_name):
                continue
            service_results = {}
            for policy_id, policy_details in service_policies.items():
                if not self.is_policy_id_excluded(policy_id=policy_id):
                    if no_params:
                        if policy_details.get("no_params"):
                            policy_definition = self.get_policy_definition(policy_id=policy_details.get("short_id"))
                            service_results[policy_details.get("display_name")] = dict(
                                short_id=policy_details.get("short_id"),
                                long_id=policy_definition.id,
                                display_name=policy_details.get("display_name").replace("[Preview]: ", ""),
                            )
                    if params_optional:
                        if policy_details.get("params_optional"):
                            parameters = {}
                            policy_definition = self.get_policy_definition(policy_id=policy_details.get("short_id"))
                            # Get the policy definition ID
                            # Look up the policy definition and set the object
                            # For parameter name, parameter details, do stuff from get_policy_definition_parameters
                            for parameter_name, parameter_details in policy_definition.parameters.items():
                                if parameter_details.name == "effect":
                                    continue
                                parameters[parameter_details.name] = parameter_details.json()
                            service_results[policy_details.get("display_name")] = dict(
                                short_id=policy_details.get("short_id"),
                                long_id=policy_definition.id,
                                display_name=policy_details.get("display_name").replace("[Preview]: ", ""),
                                parameters=parameters
                            )
                    if params_required:
                        if policy_details.get("params_required"):
                            parameters = {}
                            policy_definition = self.get_policy_definition(policy_id=policy_details.get("short_id"))
                            # Get the policy definition ID
                            # Look up the policy definition and set the object
                            # For parameter name, parameter details, do stuff from get_policy_definition_parameters
                            for parameter_name, parameter_details in policy_definition.parameters.items():
                                if parameter_details.name == "effect":
                                    continue
                                parameters[parameter_details.name] = parameter_details.json()
                            service_results[policy_details.get("display_name")] = dict(
                                short_id=policy_details.get("short_id"),
                                long_id=policy_definition.id,
                                display_name=policy_details.get("display_name").replace("[Preview]: ", ""),
                            )
                    # If audit_only is flagged, create a new list to hold the audit-only ones, then save it as the new service results
                    if audit_only:
                        filtered_service_results = {}
                        for service_result, service_result_details in service_results.items():
                            if policy_details.get("audit_only"):
                                filtered_service_results[service_result] = service_result_details
                        service_results = filtered_service_results.copy()

                    service_results = OrderedDict(sorted(service_results.items()))

                    # If audit_only is not used, don't worry about it
                    if service_results:
                        results[service_name] = service_results
        # Trim the irrelevant services
        policy_id_pairs = {}
        for service_name, service_policies in results.items():
            if service_name in self.service_names:
                policy_id_pairs[service_name] = service_policies
        return policy_id_pairs

    def compliance_coverage_data(self, no_params: bool = True, params_optional: bool = True, params_required: bool = True) -> dict:
        results = {}
        compliance_data_file = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__), os.path.pardir, "shared", "../shared/data", "compliance-data.json"
            )
        )
        with open(compliance_data_file) as json_file:
            compliance_data = json.load(json_file)
        display_names_sorted = self.get_all_display_names_sorted_by_service(no_params=no_params, params_optional=params_optional, params_required=params_required)
        definitions_found = []
        for service_name, display_names in display_names_sorted.items():
            for display_name in display_names:
                policy_definition_compliance_metadata = compliance_data.get(display_name, None)
                # If there are no results, skip
                if not policy_definition_compliance_metadata:
                    continue
                # Check if this is excluded by the config
                policy_definition = self.get_policy_definition_by_display_name(display_name)
                if skip_display_names(policy_definition=policy_definition, config=self.config):
                    continue
                definitions_found.append(f"{service_name}: {display_name}")
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
                    service_results[display_name] = policy_def_results
                else:
                    continue
                if not results.get(service_name):
                    results[service_name] = service_results
                else:
                    results[service_name][display_name] = policy_def_results
        # Address items that are not listed under the compliance benchmarks
        for service_name, display_names in display_names_sorted.items():
            for display_name in display_names:
                service_results = {}
                if service_name in results.keys():
                    if display_name in results[service_name].keys():
                        continue
                definitions_found.append(f"{service_name}: {display_name}")
                # Check if this is excluded by the config
                policy_definition = self.get_policy_definition_by_display_name(display_name)
                if skip_display_names(policy_definition=policy_definition, config=self.config):
                    continue
                if not policy_definition:
                    raise Exception(f"Policy definition with display name {display_name} not found")
                policy_def_results = dict(
                    description=policy_definition.properties.description,
                    effects=','.join(policy_definition.allowed_effects),
                    github_link=policy_definition.github_link,
                    github_version=policy_definition.properties.version,
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
        definitions_found.sort()
        return results

    def table_summary(self, hyperlink_format: bool = True, no_params: bool = True, params_optional: bool = True, params_required: bool = True) -> list:
        results = []

        def get_benchmark_id(benchmark_name: str, this_policy_metadata: dict) -> str:
            if this_policy_metadata["benchmarks"].get(benchmark_name, None):
                benchmark_id = this_policy_metadata["benchmarks"][benchmark_name]["requirement_id"]
                benchmark_id = benchmark_id.replace(f"{benchmark_name}: ", "")
                benchmark_id = benchmark_id.replace(f"ID : ", "")
            else:
                benchmark_id = ""
            return benchmark_id

        compliance_coverage_data = self.compliance_coverage_data(no_params=no_params, params_optional=params_optional, params_required=params_required)
        for service_name, service_details in compliance_coverage_data.items():
            for display_name, policy_metadata in service_details.items():
                name = display_name.replace("[Preview]: ", "")
                github_link = policy_metadata.get("github_link")
                policy_definition_obj = self.get_policy_definition_by_display_name(display_name)

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
                # Store Audit only result as a string
                if policy_definition_obj.audit_only:
                    audit_only = "Yes"
                else:
                    audit_only = "No"
                result = {
                    "Service": service_name,
                    "Policy Definition": policy_definition_string,
                    "Parameter Requirements": parameter_requirements,
                    "Audit Only": audit_only,
                    "Azure Security Benchmark": azure_security_benchmark_id,
                    "CIS": cis_id,
                    "CCMC L3": ccmc_id,
                    "ISO 27001": iso_id,
                    "NIST SP 800-171 R2": nist_800_171_id,
                    "NIST SP 800-53 R4": nist_800_53_id,
                    "HIPAA HITRUST 9.2": hipaa_id,
                    "New Zealand ISM": new_zealand_id,
                    "Parameters": parameter_names,
                    "Link": github_link,
                    "ID": policy_definition_obj.short_id
                }
                results.append(result)
        results = sorted(results, key=itemgetter("Service", "Policy Definition"))
        return results

    def csv_summary(self, path: str, verbosity: int, no_params: bool = True, params_optional: bool = True, params_required: bool = True):
        headers = [
            "Service",
            "Policy Definition",
            "Parameter Requirements",
            "Audit Only",
            "Azure Security Benchmark",
            "CIS",
            "CCMC L3",
            "ISO 27001",
            "NIST SP 800-53 R4",
            "NIST SP 800-171 R2",
            "HIPAA HITRUST 9.2",
            "New Zealand ISM",
            "Parameters",
            "Link",
            "ID"
        ]

        # results = headers.copy()
        results = self.table_summary(hyperlink_format=False, no_params=no_params, params_optional=params_optional, params_required=params_required)
        if os.path.exists(path):
            os.remove(path)
            if verbosity >= 1:
                utils.print_grey(f"Removing the previous file: {path}")

        with open(path, "w", newline="") as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=headers)
            writer.writeheader()
            for row in results:
                writer.writerow(row)
            if verbosity >= 1:
                utils.print_grey(f"Wrote the new file to {path}")

    def markdown_table(self, no_params: bool = True, params_optional: bool = True, params_required: bool = True) -> str:
        results = self.table_summary(no_params=no_params, params_optional=params_optional, params_required=params_required)
        return tabulate(results, headers="keys", tablefmt="github")

