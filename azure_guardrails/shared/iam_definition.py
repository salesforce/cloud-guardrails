"""
Single data source for the Policy Definition. It combines the azure-policy GitHub module into a single JSON file
"""
import os
import json
import operator
from collections import OrderedDict

import logging
from azure_guardrails.shared import utils
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config
from azure_guardrails.guardrails.policy_definition import PolicyDefinition
from azure_guardrails.guardrails.services import PolicyDefinition

logger = logging.getLogger(__name__)

default_service_names = utils.get_service_names()
default_service_names.sort()

iam_definition_path = os.path.join(utils.DATA_FILE_DIRECTORY, "iam-definition.json")
with open(iam_definition_path, "r") as file:
    iam_definition = json.load(file)


class AzurePolicies:
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
        self.service_definitions = iam_definition["service_definitions"]
        self.policy_definitions = iam_definition["policy_definitions"]

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

    def get_policy_id_parameters(self, policy_id: str) -> dict:
        policy_definition = self.get_policy_definition(policy_id=policy_id)
        parameters = {}
        for parameter_name, parameter_details in policy_definition.parameters.items():
            if parameter_details.name == "effect":
                continue
            parameters[parameter_details.name] = parameter_details.json()
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
            service_results = {}
            for policy_id, policy_details in service_policies.items():
                if not self.is_policy_id_excluded(policy_id=policy_id):
                    if no_params:
                        if policy_details.get("no_params"):
                            service_results[policy_details.get("display_name")] = dict(
                                short_id=policy_details.get("short_id"),
                                display_name=policy_details.get("display_name")
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
                                display_name=policy_details.get("display_name"),
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
                                display_name=policy_details.get("display_name")
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
        return results


example = {
    "service_definitions": {
        "API for FHIR": {
            # This way we can look up by .items(): and sort according to the metadata, then look up from policy_definitions directly
            "051cba44-2429-45b9-9649-46cec11c7119": {
                "display_name": "Azure API for FHIR should use a customer-managed key to encrypt data at rest",
                "allowed_effects": [],
                "no_params": True,
                "params_optional": False,
                "params_required": False,
                "is_deprecated": False,
                "audit_only": False,
                "modifies_resources": False,
                "parameter_names": [],
            }
        }
        # Other services here
    },
    "policy_definitions": {
        "051cba44-2429-45b9-9649-46cec11c7119": {
            "display_name": "Azure API for FHIR should use a customer-managed key to encrypt data at rest",
            "service_name": "API for FHIR",
            "name": "051cba44-2429-45b9-9649-46cec11c7119",
            "short_id": "051cba44-2429-45b9-9649-46cec11c7119",
            "id": "/providers/Microsoft.Authorization/policyDefinitions/051cba44-2429-45b9-9649-46cec11c7119",
            "policy_rule": {}
        },
        # Other policy definitions, you can look them up by ID
        "1ee56206-5dd1-42ab-b02d-8aae8b1634ce": {
            "display_name": "Azure API for FHIR should use private link",
            "service_name": "API for FHIR",
            "name": "1ee56206-5dd1-42ab-b02d-8aae8b1634ce",
            "short_id": "051cba44-2429-45b9-9649-46cec11c7119",
            "id": "/providers/Microsoft.Authorization/policyDefinitions/1ee56206-5dd1-42ab-b02d-8aae8b1634ce",
            "policy_rule": {}
        }
    }
}
