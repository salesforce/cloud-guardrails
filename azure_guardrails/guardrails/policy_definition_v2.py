import os
import logging
import json
from typing import List, Optional, Dict

logger = logging.getLogger(__name__)


class PolicyDefinitionV2:
    """
    Policy Definition structure

    https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure
    """
    def __init__(self, policy_content: dict, service_name: str):
        self.content = policy_content
        self.service_name = service_name

        self.id = policy_content.get("id")
        self.name = policy_content.get("name")
        self.category = policy_content.get("properties").get("metadata").get("category", None)
        self.properties = PropertiesV2(properties_json=policy_content.get("properties"))
        self.display_name = self.properties.display_name
        self.parameters = self.properties.parameters

    def __repr__(self):
        return json.dumps(self.json())
        # return json.dumps(self.content)

    def __str__(self):
        return json.dumps(self.json())
        # return json.dumps(self.content)

    def json(self) -> dict:
        result = dict(
            id=self.id,
            name=self.name,
            category=self.category,
            display_name=self.display_name,
        )
        if self.parameters:
            result["parameters"] = self.properties.parameter_json,
        return result

    @property
    def parameter_names(self) -> list:
        """Return the list of parameter names"""
        parameters = []
        parameters.extend(self.properties.parameter_names)
        return parameters

    @property
    def no_params(self) -> bool:
        """Return true if there are no parameters for the Policy Definition or if the only parameter is 'effect'"""
        result = True
        if self.properties.parameters:
            for parameter in self.properties.parameters:
                if parameter == "effect":
                    continue
                else:
                    result = False
                    break
        return result

    @property
    def params_optional(self) -> bool:
        """Return true if there are parameters for the Policy Definition and they have default values, making them optional"""
        result = True
        if self.no_params:
            # We will return False, because there are no params at all - optional or not.
            return False
        for parameter, parameter_details in self.parameters.items():
            if parameter == "effect":
                continue
            # We should allow you to print out the options to a YAML file and fill it out like a form.
            # So right now, it will create a long Kubernetes policy, but it will have lots of empty lists that we have to fill out. Oh well.
            if not parameter_details.default_value:
                # if not parameter.default_value and parameter.default_value != [] and parameter.default_value != "":
                result = False
                break
        return result

    @property
    def params_required(self) -> bool:
        """Return true if there are parameters for the Policy Definition and they are not optional"""
        if self.no_params or self.params_optional:
            return False
        else:
            return True

    @property
    def allowed_effects(self) -> list:
        allowed_effects = []
        try:
            effect_parameter = self.properties.parameters.get("effect")
            allowed_effects = effect_parameter.allowed_values

        # This just means that there is no effect in there.
        except AttributeError as error:
            # Weird cases: where deployifnotexists or modify are in the body of the policy definition instead of the "effect" parameter
            # In this case, we have an 'if' statement that greps for deployifnotexists in str(policy_definition.lower())
            if 'deployifnotexists' in str(self.properties.policy_rule).lower() and 'modify' in str(
                    self.properties.policy_rule):
                logger.debug(
                    f"Found BOTH deployIfNotExists and modify in the policy content for the policy: {self.display_name}")
                allowed_effects.append("deployIfNotExists")
                allowed_effects.append("modify")
            elif 'deployifnotexists' in str(self.properties.policy_rule).lower():
                logger.debug(f"Found deployIfNotExists in the policy content for the policy: {self.display_name}")
                allowed_effects.append("deployIfNotExists")
            elif 'modify' in str(self.properties.policy_rule).lower():
                logger.debug(f"Found Modify in the policy content for the policy: {self.display_name}")
                allowed_effects.append("modify")
            elif 'append' in str(self.properties.policy_rule).lower():
                logger.debug(f"Found append in the policy content for the policy: {self.display_name}")
                allowed_effects.append("append")
            else:
                logger.debug(error)

        # Normalize names
        if allowed_effects:
            lowercase_allowed_effects = [x.lower() for x in allowed_effects]
            return lowercase_allowed_effects
        else:
            return []

    @property
    def modifies_resources(self) -> bool:
        # Effects: https://docs.microsoft.com/en-us/azure/governance/policy/concepts/effects
        if (
            "append" in self.allowed_effects
            or "modify" in self.allowed_effects
            or "deployifnotexists" in self.allowed_effects
        ):
            logger.debug(f"{self.service_name} - modifies_resources: The policy definition {self.display_name} has the allowed_effects: {self.allowed_effects}")
            return True
        else:
            return False

    @property
    def is_deprecated(self) -> bool:
        """Determine whether the policy is deprecated or not"""
        if self.properties.deprecated:
            return True
        else:
            return False


class ParameterV2:
    """
    Parameter properties

    https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#parameter-properties
    """
    def __init__(self, name: str, parameter_json: dict):
        self.name = name
        self.type = parameter_json.get("type")
        # Do some weird stuff because in this case, [] vs None has different implications
        if "defaultValue" in str(parameter_json):
            default_value = parameter_json.get("defaultValue", None)
            if default_value:
                self.default_value = default_value
            else:
                if self.type == "Array":
                    self.default_value = []
                else:
                    self.default_value = None

        self.default_value = parameter_json.get("defaultValue", None)
        self.allowed_values = parameter_json.get("allowedValues", None)

        # Metadata
        self.metadata_json = parameter_json.get("metadata")
        self.description = self.metadata_json.get("description")
        self.display_name = self.metadata_json.get("displayName")
        self.schema = self.metadata_json.get("schema", None)
        self.category = self.metadata_json.get("category", None)
        self.strong_type = self.metadata_json.get("strongType", None)
        self.assign_permissions = self.metadata_json.get("assignPermissions", None)

    def __repr__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            name=self.name,
            type=self.type,
            description=self.description,
            display_name=self.display_name,
        )
        # Return default value only if it has a value, or if it is an empty list or empty string
        if self.default_value or self.default_value == [] or self.default_value == "":
            result["default_value"] = self.default_value
        if self.allowed_values:
            result["allowed_values"] = self.allowed_values
        if self.category:
            result["category"] = self.category
        if self.strong_type:
            result["strong_type"] = self.strong_type
        if self.assign_permissions:
            result["assign_permissions"] = self.assign_permissions
        return result

    def _allowed_values(self, parameter_json):
        allowed_values = parameter_json.get("allowedValues", None)
        allowed_values = [x.lower() for x in allowed_values]
        return allowed_values


class PropertiesV2:
    def __init__(self, properties_json: dict):
        self.properties_json = properties_json
        # Values
        display_name = properties_json.get("displayName")
        self.policy_type = properties_json.get("policyType")
        self.mode = properties_json.get("mode")
        self.description = properties_json.get("description")

        # Metadata
        self.metadata_json = properties_json.get("metadata")
        self.version = self.metadata_json.get("version", None)
        self.category = self.metadata_json.get("category", None)
        self.preview = self.metadata_json.get("preview", None)
        if self.preview:
            self.display_name = f"[Preview]: {display_name}"
        else:
            self.display_name = display_name
        self.deprecated = self.metadata_json.get("deprecated", None)

        # PolicyDefinition Rule and Parameters
        self.policy_rule = properties_json.get("policyRule")
        # self.parameters_json = properties_json.get("parameters")
        self.parameters = self._parameters(properties_json.get("parameters"))

    def __repr__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            policy_type=self.policy_type,
            mode=self.mode,
            description=self.description,
            version=self.version,
            preview=self.version,
            display_name=self.version,
            deprecated=self.version,
            policy_rule=self.version,
        )
        if self.parameters:
            parameters_result = {}
            for parameter in self.parameters:
                parameters_result[parameter.name] = parameter.json()
            result["parameters"] = parameters_result
        return result

    # def _parameters(self, parameters_json: dict) -> Dict[Optional[ParameterV2]]:
    def _parameters(self, parameters_json: dict) -> dict:
        # def _parameters(self) -> dict:
        parameters = {}
        if parameters_json:
            for name, value in parameters_json.items():
                parameter = ParameterV2(name=name, parameter_json=value)
                parameters[name] = parameter
        return parameters

    @property
    def parameter_names(self) -> list:
        if self.parameters:
            return list(self.parameters.keys())
        else:
            return []

    @property
    def parameter_json(self) -> dict:
        result = {}
        if self.parameters:
            for name, value in self.parameters.items():
                result[name] = value.json()
            return result
        else:
            return {}
