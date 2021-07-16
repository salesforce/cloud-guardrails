# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import os
import json
from typing import Union
from jinja2 import Environment, FileSystemLoader
from cloud_guardrails.shared import utils


class TerraformTemplateNoParams:
    """Terraform Template for when there are no parameters"""

    def __init__(
            self,
            policy_id_pairs: dict,
            subscription_name: str = "",
            management_group: str = "",
            enforcement_mode: bool = False,
            category: str = "Testing"
    ):
        self.label = "no_params"  # This is just used for naming Terraform resources and variables
        self.enforce = enforcement_mode
        self.initiative_name = self._initiative_name(
            subscription_name=subscription_name, management_group=management_group
        )
        self.subscription_name = subscription_name
        self.management_group = management_group
        self.policy_id_pairs = self._policy_id_pairs(policy_id_pairs)
        if enforcement_mode:
            self.enforcement_string = "true"
        else:
            self.enforcement_string = "false"
        self.category = category

    def _initiative_name(self, subscription_name: str, management_group: str) -> str:
        if subscription_name == "" and management_group == "":
            raise Exception(
                "Please supply a value for the subscription name or the management group"
            )
        parameter_requirement_str = "NP"
        if self.enforce:
            parameter_requirement_str = "NP-Enforce"
        else:
            parameter_requirement_str = f"{parameter_requirement_str}-Audit"
        if subscription_name:
            initiative_name = utils.format_policy_name(subscription_name, parameter_requirement_str)
        else:
            initiative_name = utils.format_policy_name(management_group, parameter_requirement_str)
        return initiative_name

    @staticmethod
    def _policy_id_pairs(policy_id_pairs: dict) -> dict:
        example_input = {
            "API for FHIR": {
                "051cba44-2429-45b9-9649-46cec11c7119": {
                    "display_name": "Azure API for FHIR should use a customer-managed key to encrypt data at rest",
                    "short_id": "051cba44-2429-45b9-9649-46cec11c7119"
                },
                "1ee56206-5dd1-42ab-b02d-8aae8b1634ce": {
                    "display_name": "Azure API for FHIR should use private link",
                    "short_id": "1ee56206-5dd1-42ab-b02d-8aae8b1634ce"
                }
            }
        }
        all_valid_services = utils.get_service_names()
        # Just validate the input, that's all
        for service_name, service_policies in policy_id_pairs.items():
            if service_name not in all_valid_services:
                raise Exception("The service provided is not a valid service")
            for policy_id, policy_details in service_policies.items():
                if not policy_details.get("display_name", None):
                    raise Exception("There should be a display name")
                if not policy_details.get("short_id", None):
                    raise Exception("There should be a short_id")
        return policy_id_pairs

    def rendered(self) -> str:
        template_contents = dict(
            label=self.label,
            initiative_name=self.initiative_name,
            policy_id_pairs=self.policy_id_pairs,
            subscription_name=self.subscription_name,
            management_group=self.management_group,
            enforcement_mode=self.enforcement_string,
            category=self.category
        )
        template_path = os.path.join(os.path.dirname(__file__), "no-parameters")
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        template = env.get_template("policy-initiative-no-params.tf.j2")
        return template.render(t=template_contents)


class TerraformParameter:
    def __init__(
            self, name: str, service: str, policy_definition_name: str, initiative_parameters_json: dict,
            parameter_type: str,
            default_value: Union[list, str, dict, bool, int],
            value: Union[list, str, dict, bool, int] = None
    ):
        """
        Policy Parameter data prepped for usage in the Terraform templates. https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#parameter-properties

        :param name: Name of the parameter, like evaluatedSkuNames. This goes under the azurerm_policy_set_definition as well as the parameters section in azurerm_policy_assignment
        :param service: The service name, like App Platform
        :param policy_definition_name: The display name of the policy definition for this parameter - like 'API Management services should use a virtual network'. Need to figure out if we will handle duplicates, or if this value will be used.
        :param initiative_parameters_json: the JSON per-parameter under the parameters section in azurerm_policy_set_definition. This will be inserted in the template in a for loop
        :param default_value: The default value that we will assign in azurerm_policy_assignment. Either a list or a string
        :param parameter_type: The type of parameter - string, array, object, boolean, integer, float, or datetime. Keeping here in case.
        """
        self.name = name
        self.service = service
        self.policy_definition_name = policy_definition_name
        self.initiative_parameters_json = initiative_parameters_json
        self.parameter_type = parameter_type
        self.default_value = default_value
        self.value = self._value(value)

    def _value(self, value):
        """If value is not set, set it to default_value. Default value can be overridden later."""
        if not value:
            return self.default_value
        else:
            return value

    @staticmethod
    def _parameter_type(parameter_type: str) -> str:
        """Check the parameter type"""
        allowed_parameter_types = ["string", "array", "object", "integer", "float", "datetime"]
        if parameter_type.lower() not in allowed_parameter_types:
            raise Exception(f"The Parameter type must be one of {','.join(allowed_parameter_types)}")
        return parameter_type

    # # TODO: This is where we can modify the parameter values
    @property
    def policy_definition_reference_value(self):
        """azurerm_policy_set_definition.policy_definition_reference.parameter_values: the 'value' section here"""
        return f"[parameters('{self.name}')]"

    def json(self) -> dict:
        result = dict(
            name=self.name,
            service=self.service,
            policy_definition_name=self.policy_definition_name,
            initiative_parameters_json=self.initiative_parameters_json,
            default_value=self.default_value,
            parameter_type=self.parameter_type,
        )
        return result

    @property
    def policy_assignment_parameter_value(self) -> str:
        """Produces the string ' evaluatedSkuNames = { "value" : ["Standard"] }' for use in the Policy Assignment parameters section"""
        value = json.dumps(self.value)
        result = f"{self.name} = {{ \"value\" = {value} }}"
        return result

    def __repr__(self) -> str:
        return json.dumps(self.json())

