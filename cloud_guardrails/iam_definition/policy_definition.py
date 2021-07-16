# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import logging
import json
from cloud_guardrails.iam_definition.properties import Properties
from cloud_guardrails.shared import utils
logger = logging.getLogger(__name__)


class PolicyDefinition:
    """
    Policy Definition structure

    https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure
    """

    def __init__(self, policy_content: dict, service_name: str, file_name: str = None):
        self.content = policy_content
        self.service_name = service_name

        self.id = policy_content.get("id")
        self.name = policy_content.get("name")
        self.short_id = policy_content.get("name")
        self.file_name = file_name
        self.github_link = utils.get_github_link(service_name=service_name, file_name=file_name)
        self.category = (
            policy_content.get("properties").get("metadata").get("category", None)
        )
        self.properties = Properties(properties_json=policy_content.get("properties"))
        self.display_name = self.properties.display_name
        self.parameters = self.properties.parameters
        self.policy_rule = self.properties.policy_rule

    def __repr__(self):
        return json.dumps(self.json())

    def __str__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            service_name=self.service_name,
            display_name=self.display_name,
            short_id=self.name,
            id=self.id,
            name=self.name,
            github_link=self.github_link,
            category=self.category,
            allowed_effects=self.allowed_effects,
            parameter_names=self.parameter_names,
            no_params=self.no_params,
            params_optional=self.params_optional,
            params_required=self.params_required,
            is_deprecated=self.is_deprecated,
            modifies_resources=self.modifies_resources,
        )
        if self.parameters:
            result["parameters"] = self.properties.parameter_json
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

    def get_optional_parameters(self) -> list:
        """Return a list of optional parameters"""
        results = []
        if self.no_params or self.params_required:
            return []
        else:
            for parameter, parameter_details in self.parameters.items():
                if parameter == "effect":
                    continue
                if parameter_details.default_value:
                    results.append(parameter_details.name)
        return results

    def get_required_parameters(self) -> list:
        """Return a list of required parameters"""
        results = []
        if self.no_params or self.params_optional:
            return []
        else:
            for parameter, parameter_details in self.parameters.items():
                if parameter == "effect":
                    continue
                if not parameter_details.default_value:
                    results.append(parameter_details.name)
        return results

    @property
    def allowed_effects(self) -> list:
        allowed_effects = []
        if self.properties.parameters.get("effect", None):
            allowed_effects = self.properties.parameters.get("effect", None).allowed_values
        # # try:
        # #     effect_parameter = self.properties.parameters.get("effect")
        #
        # # This just means that there is no effect in there.
        # except AttributeError as error:
        #     # Weird cases: where deployifnotexists or modify are in the body of the policy definition instead of the "effect" parameter
        #     # In this case, we have an 'if' statement that greps for deployifnotexists in str(policy_definition.lower())
        #     # logger.debug(error)
        #     logger.debug(f"AttributeError for policy name: {self.properties.display_name}. {error}")

        # Handle cases where the effect is not in there.
        then_effect = self.properties.policy_rule.get("then").get("effect")
        if "parameters" not in then_effect:
            allowed_effects.append(then_effect)

        if "deployifnotexists" in str(
            self.properties.policy_rule
        ).lower() and "modify" in str(self.properties.policy_rule).lower():
            logger.debug(
                f"Found BOTH deployIfNotExists and modify in the policy content for the policy: {self.display_name}"
            )
            allowed_effects.append("deployIfNotExists")
            allowed_effects.append("modify")
        elif "deployifnotexists" in str(self.properties.policy_rule).lower():
            logger.debug(
                f"Found deployIfNotExists in the policy content for the policy: {self.display_name}"
            )
            allowed_effects.append("deployIfNotExists")
        elif "modify" in str(self.properties.policy_rule).lower():
            logger.debug(
                f"Found Modify in the policy content for the policy: {self.display_name}"
            )
            allowed_effects.append("modify")
        elif "append" in str(self.properties.policy_rule).lower():
            logger.debug(
                f"Found append in the policy content for the policy: {self.display_name}"
            )
            allowed_effects.append("append")
        else:
            pass
            # logger.debug(f"No deploy effect found for {self.display_name}")

        # Normalize names
        if allowed_effects:
            lowercase_allowed_effects = [x.lower() for x in allowed_effects]
            # Remove duplicates
            lowercase_allowed_effects = list(dict.fromkeys(lowercase_allowed_effects))
            return lowercase_allowed_effects
        else:
            return []

    @property
    def audit_only(self) -> bool:
        """Determine if the effect is only audit or auditIfNotExists"""
        result = True
        for effect in self.allowed_effects:
            if effect not in ["disabled", "audit", "auditifnotexists"]:
                result = False
        return result

    @property
    def modifies_resources(self) -> bool:
        # Effects: https://docs.microsoft.com/en-us/azure/governance/policy/concepts/effects
        if (
            "append" in self.allowed_effects
            or "modify" in self.allowed_effects
            or "deployifnotexists" in self.allowed_effects
        ):
            logger.debug(
                f"{self.service_name} - modifies_resources: The policy definition {self.display_name} has the allowed_effects: {self.allowed_effects}"
            )
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

    def parameters_config(self) -> dict:
        """Return the parameters config for this policy definition"""
        if not self.params_optional and not self.params_required:
            return {}
        parameters = dict()
        for parameter, parameter_details in self.parameters.items():
            parameters[parameter_details.name] = parameter_details.parameter_config()
        return parameters
