from jinja2 import Template, Environment, FileSystemLoader
import os
import json
import copy
import yaml
import logging
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared.config import DEFAULT_CONFIG
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import PolicyDefinition

DEFAULT_PARAMETERS_FILE = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "default-parameters-config.yml")
)
logger = logging.getLogger(__name__)

def get_parameters_template() -> str:
    # if not categorized_parameters:
    #     with open(DEFAULT_PARAMETERS_FILE, "r") as file:
    #         default_categorized_parameters = yaml.safe_load(file)
    #     categorized_parameters = default_categorized_parameters
    azure_policies = AzurePolicies(service_names=["all"], config=DEFAULT_CONFIG)
    categorized_parameters = OverallCategorizedParameters(azure_policies=azure_policies, params_optional=True, params_required=True, audit_only=False)
    template_contents = dict(
        categorized_parameters=categorized_parameters.service_categorized_parameters,
    )
    template_path = os.path.join(os.path.dirname(__file__))
    env = Environment(loader=FileSystemLoader(template_path))  # nosec

    def is_list(value):
        return isinstance(value, list)

    env.tests['is_a_list'] = is_list
    env.filters["debug"] = print
    env.filters['tojson'] = json.dumps
    env.tests['is_none_instance'] = utils.is_none_instance
    template = env.get_template("parameters-template.yml.j2")
    return template.render(t=template_contents)


class OverallCategorizedParameters:
    """Feed the results of the JSON File into here and store it in the class structure"""

    def __init__(
        self,
        azure_policies: AzurePolicies = AzurePolicies(service_names=["all"], config=DEFAULT_CONFIG),
        parameters_config: dict = None,
        params_optional: bool = False,
        params_required: bool = False,
        audit_only: bool = False
    ):
        self.params_optional = params_optional
        self.params_required = params_required
        self.audit_only = audit_only
        self.azure_policies = azure_policies
        if parameters_config:
            self.parameters_config = self.set_parameters_config(parameters_config)
        else:
            self.parameters_config = {}
        self.service_categorized_parameters = self.set_service_categorized_parameters()

    def set_parameters_config(self, parameters_config: dict) -> dict:
        # If the parameters config has invalid values, this will throw an exception
        self.validate_parameters_config(parameters_config=parameters_config)
        return parameters_config

    def validate_parameters_config(self, parameters_config: dict):
        """If the parameters config has invalid values, this will throw an exception"""
        # Validate the input first
        # Let's validate the top level keys.
        valid_service_names = utils.get_service_names()
        for service_name, service_policies in parameters_config.items():
            # Service name should be valid
            if service_name not in valid_service_names:
                raise Exception(
                    f"The service name {service_name} is not a valid service name. Please adjust your config file.")
            for policy_name, policy_parameters in service_policies.items():
                policy_definition = self.azure_policies.get_policy_definition_by_display_name(display_name=policy_name)
                if not policy_definition:
                    raise Exception(
                        f'"{policy_name}" was not found in the policy definitions. Check the spelling and list of policy display names and try again.')
                for parameter_name, parameter_value in policy_parameters.items():
                    # Parameter name must be valid
                    if parameter_name not in policy_definition.parameters:
                        raise Exception(
                            f"The parameter {parameter_name} in the policy {policy_name} under the {service_name} is not valid. Please provide a valid value.")
                        # If allowed_values are supplied, make sure the values are legit
                    if policy_definition.properties.parameters[parameter_name].allowed_values:
                        allowed_values = policy_definition.properties.parameters[parameter_name].allowed_values
                        # if the supplied value is a list, make sure it matches the allowed values
                        if isinstance(parameter_value, list):
                            for value in parameter_value:
                                if value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                                    raise Exception(
                                        f"The value {value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")
                        else:
                            # If the parameter name is effect, let's evaluate in lowercase
                            if parameter_name.lower() == "effect":
                                lowercase_allowed_values = [x.lower() for x in allowed_values]
                                if parameter_value.lower() not in lowercase_allowed_values:
                                    raise Exception(
                                        f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")
                            # If the name is not effect, we can evaluate case sensitive
                            else:
                                if parameter_value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                                    raise Exception(
                                        f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")

    def set_service_categorized_parameters(self):
        all_policy_ids_sorted_by_service = self.azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False,
            params_optional=self.params_optional,
            params_required=self.params_required,
            audit_only=self.audit_only
        )
        results = {}
        for service_name, service_policies in all_policy_ids_sorted_by_service.items():
            # Case: "all"
            if "all" in self.azure_policies.service_names:
                pass
            elif service_name in self.azure_policies.service_names:
                pass
            else:
                continue
            # if service_name not in self.azure_policies.service_names:
            #     continue
            self.validate_service_name(service_name=service_name, service_names=self.azure_policies.service_names)
            results[service_name] = {}
            for policy_name, policy_details in service_policies.items():
                # If "parameters" doesn't exist, that means the Policy Definition doesn't accept parameters and we should skip it
                policy_definition = self.azure_policies.get_policy_definition(policy_id=policy_details.get("short_id"))
                # See if it has parameters
                if not policy_definition.parameters:
                    # if "parameters" not in policy_details.keys():
                    continue
                results[service_name][policy_name] = {}
                # policy_definition = self.azure_policies.get_policy_definition_by_display_name(display_name=policy_name)
                # policy_parameters = policy_details.get("parameters", None)

                for parameter_name in policy_definition.parameters:
                    if policy_definition.properties.parameters[parameter_name].allowed_values:
                        # If allowed_values are supplied, make sure the values are legit
                        if policy_definition.properties.parameters[parameter_name].allowed_values:
                            allowed_values = policy_definition.properties.parameters[parameter_name].allowed_values
                            self.validate_allowed_parameter_values(policy_name=policy_name, service_name=service_name,
                                                                   policy_definition=policy_definition,
                                                                   allowed_values=allowed_values,
                                                                   parameter_name=parameter_name, parameter_value=None)
                            results[service_name][policy_name][parameter_name] = policy_definition.parameters[
                                parameter_name].json()
                    else:
                        results[service_name][policy_name][parameter_name] = policy_definition.parameters[
                            parameter_name].json()

                # Let's also store the policy ID as a parameter, even though that isn't a thing
                results[service_name][policy_name]["policy_id"] = policy_definition.short_id
        return results

    @staticmethod
    def validate_service_name(service_name, service_names: list):
        if service_name not in service_names:
            raise Exception(f"The service name {service_name} is not valid. Please adjust your config file.")

    @staticmethod
    def validate_allowed_parameter_values(policy_name: str, service_name: str, policy_definition: PolicyDefinition,
                                          allowed_values: list,
                                          parameter_name: str, parameter_value):
        # if the supplied value is a list, make sure it matches something from the allowed values
        if isinstance(parameter_value, list):
            for value in parameter_value:
                if value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                    raise Exception(
                        f"The value {value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")
        elif isinstance(parameter_value, type(None)):
            logger.debug(
                f"The parameter {parameter_name} was not supplied. Please provide a valid value. Display name: {policy_name}. Service: {service_name}")
        else:
            # If the parameter name is effect, let's evaluate in lowercase
            if parameter_name.lower() == "effect":
                lowercase_allowed_values = [x.lower() for x in allowed_values]
                if parameter_value.lower() not in lowercase_allowed_values:
                    raise Exception(
                        f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")
            # If the name is not effect, we can evaluate case sensitive
            else:
                if parameter_value not in policy_definition.properties.parameters[parameter_name].allowed_values:
                    raise Exception(
                        f"The value {parameter_value} is not in the list of allowed_values: {', '.join(policy_definition.properties.parameters[parameter_name].allowed_values)}. Parameter: {parameter_name}. Display name: {policy_name}. Service: {service_name}")

    def get_parameter_value_from_config(self, display_name: str, parameter_name: str):
        policy_id = self.azure_policies.get_policy_id_by_display_name(display_name=display_name)
        policy_definition = self.azure_policies.get_policy_definition(policy_id=policy_id)
        service_name = policy_definition.service_name

        parameters = self.azure_policies.get_parameters_by_policy_id(policy_id=policy_id, include_effect=True)

        # The parameter name must be supported by the policy
        if parameter_name not in parameters.keys():
            raise Exception(
                f"The parameter {parameter_name} was not found in the policy. Policy ID: {policy_id}. Parameter names: {', '.join(parameters)}")

        # Let's get the default value for that parameter, if it exists
        default_value = parameters[parameter_name].get("default_value", None)

        # Let's get the value supplied by the user
        try:
            user_supplied_value = self.service_categorized_parameters[service_name][display_name][parameter_name]
        except KeyError as missing_key:
            # logger.warning(traceback.print_exc())
            logger.debug(f"User did not supply a parameter; key {missing_key} was not found in the parameters config.")
            user_supplied_value = None

        # Python thinks [] or {} is the same as None. Let's circumvent that
        if not user_supplied_value:
            # Case: If the user-supplied value is truly None, that's okay.
            if isinstance(user_supplied_value, type(None)):
                if default_value:
                    logger.debug(
                        f"Parameter value not supplied by user. Using default value. Parameter: {parameter_name}. Value: {default_value}. Policy ID: {policy_id}")
                    return default_value
                elif isinstance(user_supplied_value, list):
                    user_supplied_value = []
                    logger.debug(
                        f"Parameter value supplied by user - an empty list. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                    return user_supplied_value
                elif isinstance(user_supplied_value, dict):
                    logger.debug(
                        f"Parameter value supplied by user - an empty object. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                    user_supplied_value = {}
                    return user_supplied_value
                else:
                    # TODO: Should throw an exception here. Let the user know that they need to supply a value!
                    logger.debug(
                        f"Parameter value not supplied by user. No default value available. Parameter: {parameter_name}. Policy ID: {policy_id}")
                    return None
            # TODO: How do we differentiate between when Azure says an empty list is okay vs when it is not?
            else:
                if isinstance(user_supplied_value, list):
                    user_supplied_value = []
                    logger.debug(
                        f"Parameter value supplied by user - an empty list. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                    return user_supplied_value
                elif isinstance(user_supplied_value, dict):
                    logger.debug(
                        f"Parameter value supplied by user - an empty object. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
                    user_supplied_value = {}
                    return user_supplied_value
                else:
                    return user_supplied_value
        else:
            logger.debug(
                f"Parameter supplied by user. Using user-supplied value. Parameter: {parameter_name}. Value: {user_supplied_value}. Policy ID: {policy_id}")
            return user_supplied_value

    def parameters(self) -> dict:
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
                        if isinstance(parameter_details.get("value", None), type(None)):
                            if isinstance(parameter_details.get("default_value", None), type(None)):
                                value = None
                            else:
                                value = parameter_details.get("default_value")
                        else:
                            value = parameter_details.get("value")
                        parameter = dict(
                            name=parameter_name,
                            service=service_name,
                            policy_definition_name=policy_definition_name,
                            initiative_parameters_json=parameter_details,
                            parameter_type=parameter_details.get("type"),
                            default_value=parameter_details.get("default_value"),
                            value=value,
                        )
                        results[service_name][policy_definition_name][parameter_name] = parameter
                else:
                    logger.warning(f"No parameters provided. Policy Name: \"{policy_definition_name}\"")
        return results
