import json
import os
import json
from typing import Union
from jinja2 import Template, Environment, FileSystemLoader


class TerraformParameterV2:
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
        result = f"{self.name} = {{ \"value\": {value} }}"
        return result

    def __repr__(self) -> str:
        return json.dumps(self.json())


class TerraformTemplateWithParamsV2:
    """Terraform Template with Parameters"""
    def __init__(
        self,
        parameters: dict,
        subscription_name: str = "",
        management_group: str = "",
        enforcement_mode: bool = False,
    ):
        self.name = self._name(
            subscription_name=subscription_name, management_group=management_group
        )
        self.service_parameters = self._parameters(parameters)
        self.subscription_name = subscription_name
        self.management_group = management_group
        if enforcement_mode:
            self.enforcement_string = "true"
        else:
            self.enforcement_string = "false"

    @staticmethod
    def _name(subscription_name: str, management_group: str) -> str:
        if subscription_name == "" and management_group == "":
            raise Exception(
                "Please supply a value for the subscription name or the management group"
            )
        # TODO: Shorten the management group name if it is over X characters
        if subscription_name:
            name = f"{subscription_name}-params"
        else:
            name = f"{management_group}-params"
        return name

    @staticmethod
    def _parameters(parameters: dict) -> dict:
        """
        Takes the output of Services.get_display_names_sorted_by_service_with_params and places them here.

        :param parameters:
        :return:
        """
        # TODO: Figure out how to supply the parameter values here if we have a parameters config file for them?
        results = {}
        for service_name, policy_definitions_with_params in parameters.items():
            results[service_name] = {}
            # results["Kubernetes"] = {  "Do not allow privileged containers in Kubernetes cluster": { "excludedNamespaces": {stuff} }}
            for policy_definition_name, parameters in policy_definitions_with_params.items():
                results[service_name][policy_definition_name] = {}
                for parameter_name, parameter_details in parameters.items():
                    # TODO: Figure out what to do if there are duplicates here.
                    parameter = TerraformParameterV2(
                        name=parameter_name,
                        service=service_name,
                        policy_definition_name=policy_definition_name,
                        initiative_parameters_json=parameter_details,
                        parameter_type=parameter_details.get("type"),
                        default_value=parameter_details.get("default_value"),
                        value=parameter_details.get("value"),
                    )
                    results[service_name][policy_definition_name][parameter_name] = parameter
                    # results[service_name][policy_definition_name].append(parameter)
        return results

    @property
    def policies_sorted_by_service(self) -> dict:
        """To be used in Terraform locals.policy_names"""
        results = {}
        for service_name, policy_definitions_with_params in self.service_parameters.items():
            keys = list(policy_definitions_with_params.keys())
            keys.sort()
            results[service_name] = keys
        return results

    @property
    def initiative_parameters(self) -> dict:
        """Dictionary of all parameters - to be stored in the Terraform azurerm_policy_set_definition.parameters"""
        results = {}
        for service_name, policy_definitions_with_params in self.service_parameters.items():
            for policy_definition_name, parameters in policy_definitions_with_params.items():
                for parameter_name, parameter_details in parameters.items():
                    results[parameter_details.name] = parameter_details.initiative_parameters_json
        return results

    def rendered(self) -> str:
        initiative_parameters = json.dumps(self.initiative_parameters, indent=4)
        template_contents = dict(
            name=self.name,
            subscription_name=self.subscription_name,
            management_group=self.management_group,
            enforcement_mode=self.enforcement_string,
            initiative_parameters=initiative_parameters,
            policies_sorted_by_service=self.policies_sorted_by_service,
            policy_definition_reference_parameters=self.service_parameters
        )
        template_path = os.path.join(os.path.dirname(__file__), "parameters-v2")
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        env.filters["debug"] = print
        template = env.get_template("policy-set-with-parameters-v2.tf")
        result = template.render(t=template_contents)
        return result
