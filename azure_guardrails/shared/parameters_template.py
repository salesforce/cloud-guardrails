from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared.parameters_categorized import OverallCategorizedParameters
from jinja2 import Template, Environment, FileSystemLoader
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import PolicyDefinition
import os


class ParameterSegment:
    def __init__(self, parameter_name: str, parameter_type: str, value=None, default_value=None,
                 allowed_values: list = None):
        self.name = parameter_name
        self.type = parameter_type
        self.allowed_values = allowed_values
        self.default_value = default_value
        self.value = value


class ParameterTemplate:
    def __init__(
        self,
        config: Config = DEFAULT_CONFIG,
        params_optional: bool = False,
        params_required: bool = False,
    ):
        self.azure_policies = AzurePolicies(service_names=["all"], config=config)
        categorized_parameters = OverallCategorizedParameters(
            azure_policies=self.azure_policies,
            params_optional=params_optional,
            params_required=params_required,
            audit_only=False
        )
        self.config = self.set_config(categorized_parameters=categorized_parameters)

    def set_config(self, categorized_parameters: OverallCategorizedParameters) -> dict:
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
            # parameter_segments=parameter_segments,
            categorized_parameters=self.config
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
