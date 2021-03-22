"""
Single data source for the Policy Definition. It combines the azure-policy GitHub module into a single JSON file
"""
import os
import json
import logging
from azure_guardrails.shared import utils
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config

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

    def policy_ids(self, service_name: str = None) -> list:
        results = []
        if service_name:
            results = list(iam_definition["service_definitions"].get(service_name).keys())
        else:
            for service in self.service_names:
                results.extend(list(iam_definition["service_definitions"].get(service).keys()))
        # results.sort()
        return results

    def lookup(self, policy_id: str, policy_property: str):
        """Looks up a policy property given a policy ID and optionally a service name"""
        result = None
        try:
            result = iam_definition["policy_definitions"].get(policy_id).get(policy_property)
        except KeyError as error:
            logger.warning(error)
        return result

    # def display_names(self, service_name: str = None) -> list:
    #
    #     display_names = list(self.policy_definitions.keys())
    #     display_names.sort()
    #     return display_names


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
