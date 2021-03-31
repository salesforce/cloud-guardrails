import logging
import json
import traceback
import yaml
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared import utils
from azure_guardrails.shared.config import DEFAULT_CONFIG
from typing import Union

default_service_names = utils.get_service_names()
default_service_names.sort()
logger = logging.getLogger(__name__)


class ParametersConfig:
    def __init__(
            self,
            parameter_config_file: str = None,
            azure_policies: AzurePolicies = AzurePolicies(service_names=["all"], config=DEFAULT_CONFIG),
            params_optional: bool = False,
            params_required: bool = False,
            audit_only: bool = False
    ):
        self.azure_policies = azure_policies

        if not params_optional and not params_required:
            raise Exception("one of no_params, params_optional, params_required must be set")

        self.params_optional = params_optional
        self.params_required = params_required
        self.audit_only = audit_only
        self.parameter_config_file = parameter_config_file
        self.config = self._config()
        self.parameters = self._parameters()

    def _config(self) -> dict:
        results = {}
        if not self.parameter_config_file:
            return {}
        with open(self.parameter_config_file, "r") as yaml_file:
            supplied_config = yaml.safe_load(yaml_file)
        # validate the config
        for service_name, service_policies in supplied_config.items():
            # Service name should be valid
            if service_name not in self.azure_policies.service_names:
                raise Exception(f"The service name {service_name} is not valid. Please adjust your config file.")
            results[service_name] = {}

            for display_name, parameter_details in service_policies.items():
                results[service_name][display_name] = {}
                policy_definition = self.azure_policies.get_policy_definition_by_display_name(display_name=display_name)
                if not policy_definition:
                    raise Exception(f'"{display_name}" was not found in the policy definitions. Check the spelling and list of policy display names and try again.')
                for parameter_name, parameter_value in parameter_details.items():
                    # Parameter name must be valid
                    if parameter_name not in policy_definition.parameters:
                        raise Exception(f"The parameter {parameter_name} in the policy {display_name} under the {service_name} is not valid. Please provide a valid value.")
                    # If allowed_values are supplied, make sure the values are legit
                    if policy_definition.properties.parameters[parameter_name].allowed_values:
                        allowed_values = policy_definition.properties.parameters[parameter_name].allowed_values
                        # if the supplied value is a list, make sure it matches the
                        if isinstance(parameter_value, list):
                            for value in parameter_value:
                                if value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                                    raise Exception(f"The value {value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {display_name}. Service: {service_name}")
                        else:
                            # If the parameter name is effect, let's evaluate in lowercase
                            if parameter_name.lower() == "effect":
                                lowercase_allowed_values = [x.lower() for x in allowed_values]
                                if parameter_value.lower() not in lowercase_allowed_values:
                                    raise Exception(f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {display_name}. Service: {service_name}")
                            # If the name is not effect, we can evaluate case sensitive
                            else:
                                if parameter_value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                                    raise Exception(f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {display_name}. Service: {service_name}")
                        results[service_name][display_name][parameter_name] = parameter_value
                    else:
                        results[service_name][display_name][parameter_name] = parameter_value
                # Let's also store the policy ID as a parameter, even though that isn't a thing
                results[service_name][display_name]["policy_id"] = policy_definition.short_id
        return results

    def _parameters(self) -> dict:
        results = {}
        policy_id_pairs = self.azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False, params_optional=self.params_optional, params_required=self.params_required,
            audit_only=self.audit_only)
        for service_name, service_policies in policy_id_pairs.items():
            results[service_name] = {}
            for policy_definition_name, policy_definition_details in service_policies.items():
                results[service_name][policy_definition_name] = {}
                if "parameters" in policy_definition_details.keys():
                    for parameter_name, parameter_details in policy_definition_details.get("parameters").items():

                        parameter = TerraformParameterV4(
                            name=parameter_name,
                            service=service_name,
                            policy_definition_name=policy_definition_name,
                            initiative_parameters_json=parameter_details,
                            parameter_type=parameter_details.get("type"),
                            default_value=parameter_details.get("default_value"),
                            # TODO: There is no value here. Need to insert it.
                            value=parameter_details.get("value"),
                        )
                        results[service_name][policy_definition_name][parameter_name] = parameter.json()
        return results

    def get_parameter_value_from_config(self, display_name: str, parameter_name: str):
        policy_id = self.azure_policies.get_policy_id_by_display_name(display_name=display_name)
        policy_definition = self.azure_policies.get_policy_definition(policy_id=policy_id)
        service_name = policy_definition.service_name

        parameters = self.azure_policies.get_parameters_by_policy_id(policy_id=policy_id, include_effect=True)

        # The parameter name must be supported by the policy
        if parameter_name not in parameters.keys():
            raise Exception(f"The parameter {parameter_name} was not found in the policy. Policy ID: {policy_id}. Parameter names: {', '.join(parameters)}")

        # Let's get the default value for that parameter, if it exists
        default_value = parameters[parameter_name].get("default_value", None)

        # Let's get the value supplied by the user
        try:
            user_supplied_value = self.config[service_name][display_name][parameter_name]
        except KeyError as missing_key:
            # logger.warning(traceback.print_exc())
            logger.debug(f"User did not supply a parameter; key {missing_key} was not found in the parameters config.")
            user_supplied_value = None

        # Python thinks [] or {} is the same as None. Let's circumvent that
        if not user_supplied_value:
            # Case: If the user-supplied value is truly None, that's okay.
            if isinstance(user_supplied_value, type(None)):
                if default_value:
                    logger.debug(f"Parameter value not supplied by user. Using default value. Parameter: {parameter_name}. Value: {default_value}. Policy ID: {policy_id}")
                    return default_value
                else:
                    # TODO: Should throw an exception here. Let the user know that they need to supply a value!
                    logger.debug(f"Parameter value not supplied by user. No default value available. Parameter: {parameter_name}. Policy ID: {policy_id}")
                    return None
            # TODO: How do we differentiate between when Azure says an empty list is okay vs when it is not?
            elif isinstance(user_supplied_value, list):
                user_supplied_value = []
                logger.debug(f"Parameter value supplied by user - an empty list. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                return user_supplied_value
            elif isinstance(user_supplied_value, dict):
                logger.debug(f"Parameter value supplied by user - an empty object. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                user_supplied_value = {}
                return user_supplied_value
        else:
            logger.debug(f"Parameter supplied by user. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
            return user_supplied_value


class TerraformParameterV4:
    def __init__(
            self,
            name: str,
            service: str,
            policy_definition_name: str,
            initiative_parameters_json: dict,
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
        self.value = value
        # self.value = self._value(value)

    def json(self) -> dict:
        result = dict(
            name=self.name,
            service=self.service,
            policy_definition_name=self.policy_definition_name,
            initiative_parameters_json=self.initiative_parameters_json,
            parameter_type=self.parameter_type,
            default_value=self.default_value,
            value=self.value
        )
        return result

    def __repr__(self):
        return json.dumps(self.json())

    def __str__(self):
        return json.dumps(self.json())

    # def _value(self, value):
    #     """If value is not set, set it to default_value. Default value can be overridden later."""
    #     if not value:
    #         return self.default_value
    #     else:
    #         return value

    @staticmethod
    def _parameter_type(parameter_type: str) -> str:
        """Check the parameter type"""
        allowed_parameter_types = ["string", "array", "object", "integer", "float", "datetime"]
        if parameter_type.lower() not in allowed_parameter_types:
            raise Exception(f"The Parameter type must be one of {','.join(allowed_parameter_types)}")
        return parameter_type

    # TODO: This is where we can modify the parameter values
    @property
    def policy_definition_reference_value(self):
        """azurerm_policy_set_definition.policy_definition_reference.parameter_values: the 'value' section here"""
        return f"[parameters('{self.name}')]"

    @property
    def policy_assignment_parameter_value(self) -> str:
        """Produces the string ' evaluatedSkuNames = { "value" : ["Standard"] }' for use in the Policy Assignment parameters section"""
        value = json.dumps(self.value)
        result = f"{self.name} = {{ \"value\" = {value} }}"
        return result

