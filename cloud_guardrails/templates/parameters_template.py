# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import os
import json
from jinja2 import Environment, FileSystemLoader
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies
from cloud_guardrails.shared.parameters_categorized import CategorizedParameters
from cloud_guardrails.shared.config import DEFAULT_CONFIG, Config
from cloud_guardrails.shared import utils


class ParameterSegment:
    def __init__(self, parameter_name: str, parameter_type: str, value=None, default_value=None,
                 allowed_values: list = None):
        self.name = parameter_name
        self.type = parameter_type
        self.allowed_values = allowed_values
        self.default_value = default_value
        self.value = value

    def json(self):
        return dict(
            name=self.name,
            type=self.type,
            allowed_values=self.allowed_values,
            default_value=self.default_value,
            value=self.value
        )

    def __repr__(self) -> str:
        return json.dumps(self.__dict__)


class ParameterTemplate:
    def __init__(
        self,
        config: Config = DEFAULT_CONFIG,
        params_optional: bool = False,
        params_required: bool = False,
    ):
        self.azure_policies = AzurePolicies(service_names=["all"], config=config)
        categorized_parameters = CategorizedParameters(
            azure_policies=self.azure_policies,
            params_optional=params_optional,
            params_required=params_required,
            audit_only=False
        )
        self.parameters_config = self.set_parameter_config(categorized_parameters=categorized_parameters)

    def json(self):
        results = {}
        for service_name, service_policies in self.parameters_config.items():
            results[service_name] = {}
            for policy_name, policy_parameters in service_policies.items():
                results[service_name][policy_name] = []
                for parameter_segment in policy_parameters:
                    results[service_name][policy_name].append(parameter_segment.json())

        return results

    def __repr__(self):
        return json.dumps(self.json())

    def set_parameter_config(self, categorized_parameters: CategorizedParameters) -> dict:
        results = {}
        for service_name, service_policies in categorized_parameters.service_categorized_parameters.items():
            results[service_name] = {}
            for policy_name, policy_parameters in service_policies.items():
                results[service_name][policy_name] = []
                policy_id = self.azure_policies.get_policy_id_by_display_name(policy_name)
                for parameter_name, parameter_details in policy_parameters.items():
                    try:
                        allowed_values = self.azure_policies.get_allowed_values_for_parameter(policy_id=policy_id, parameter_name=parameter_name)
                        default_value = self.azure_policies.get_default_value_for_parameter(policy_id=policy_id, parameter_name=parameter_name)
                        parameter_type = self.azure_policies.get_parameter_type(policy_id=policy_id, parameter_name=parameter_name)
                        parameter_segment = ParameterSegment(parameter_name=parameter_name, parameter_type=parameter_type,
                                                             default_value=default_value, value=default_value, allowed_values=allowed_values)
                        results[service_name][policy_name].append(parameter_segment)
                    except AttributeError:
                        # This occurs sometimes because the IAM definition has some parameters that are not legit, like "policy_id"
                        pass
        return results

    def rendered(self) -> str:
        template_contents = dict(
            categorized_parameters=self.parameters_config
        )
        template_path = os.path.join(os.path.dirname(__file__))
        env = Environment(loader=FileSystemLoader(template_path), lstrip_blocks=True)  # nosec
        env.tests['is_none_instance'] = utils.is_none_instance

        def is_list(value):
            return isinstance(value, list)

        env.tests['is_a_list'] = is_list

        template = env.get_template("parameters-template.yml.j2")
        result = template.render(t=template_contents)
        return result
