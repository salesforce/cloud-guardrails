import os
import json
import logging
from jinja2 import Environment, FileSystemLoader
from azure_guardrails.shared import utils
from azure_guardrails.shared.parameters_config import ParametersConfig

logger = logging.getLogger(__name__)


class TerraformTemplateWithParamsV4:
    """Terraform Template with Parameters"""
    def __init__(
            self,
            policy_id_pairs: dict,
            parameter_requirement_str: str,
            parameters_config: ParametersConfig,
            subscription_name: str = "",
            management_group: str = "",
            enforcement_mode: bool = False,
            category: str = "Testing",
    ):
        self.enforce = enforcement_mode
        self.name = self._initiative_name(
            subscription_name=subscription_name, management_group=management_group,
            parameter_requirement_str=parameter_requirement_str
        )
        self.subscription_name = subscription_name
        self.management_group = management_group
        self.category = category
        self.policy_id_pairs = self._policy_id_pairs(policy_id_pairs)
        self.parameters_config = parameters_config
        self.policy_definition_reference_parameters = self._policy_definition_reference_parameters(policy_id_pairs=policy_id_pairs, parameters_config=parameters_config)
        if enforcement_mode:
            self.enforcement_string = "true"
        else:
            self.enforcement_string = "false"

    def _initiative_name(self, subscription_name: str, management_group: str, parameter_requirement_str: str) -> str:
        if subscription_name == "" and management_group == "":
            raise Exception(
                "Please supply a value for the subscription name or the management group"
            )
        if self.enforce:
            parameter_requirement_str = f"{parameter_requirement_str}-Enforce"
        else:
            parameter_requirement_str = f"{parameter_requirement_str}-Audit"
        if subscription_name:
            initiative_name = utils.format_policy_name(subscription_name, parameter_requirement_str)
        else:
            initiative_name = utils.format_policy_name(management_group, parameter_requirement_str)
        return initiative_name

    @staticmethod
    def _policy_id_pairs(policy_id_pairs) -> dict:
        # Just validate the input, that's all
        all_valid_services = utils.get_service_names()
        for service_name, service_policies in policy_id_pairs.items():
            if service_name not in all_valid_services:
                raise Exception("The service provided is not a valid service")
            for policy_id, policy_details in service_policies.items():
                if not policy_details.get("display_name", None):
                    raise Exception("There should be a display name")
                if not policy_details.get("short_id", None):
                    raise Exception("There should be a short_id")
        return policy_id_pairs

    def _policy_definition_reference_parameters(self, policy_id_pairs: dict, parameters_config: ParametersConfig) -> dict:
        results = {}
        for service_name, service_policies in self.parameters_config.parameters.items():
            results[service_name] = {}
            # results["Kubernetes"] = {  "Do not allow privileged containers in Kubernetes cluster": { "excludedNamespaces": {stuff} }}
            for policy_definition_name, policy_definition_details in service_policies.items():
                results[service_name][policy_definition_name] = {}
                for parameter_name, parameter_value in policy_definition_details.items():
                    # TODO: Determine if the user hasn't supplied certain parameters? You will have to determine the parameters they supplied vs the policies requested.
                    value = parameters_config.get_parameter_value_from_config(display_name=policy_definition_name, parameter_name=parameter_name)
                    if not value:
                        logger.critical("No value supplied by the user. Check it.")
                    parameter = dict(
                        parameter_name=parameter_name,
                        parameter_value=value
                    )
                    results[service_name][policy_definition_name][parameter_name] = parameter
        return results

    @property
    def template_contents_json(self) -> dict:
        template_contents = dict(
            name=self.name,
            subscription_name=self.subscription_name,
            management_group=self.management_group,
            enforcement_mode=self.enforcement_string,
            policy_id_pairs=self.policy_id_pairs,
            policy_definition_reference_parameters=self.policy_definition_reference_parameters,
            category=self.category
        )
        return template_contents

    def rendered(self) -> str:
        template_path = os.path.join(os.path.dirname(__file__), "parameters-v4")
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        env.filters["debug"] = print
        template = env.get_template("policy-initiative-with-parameters-v4.tf")
        result = template.render(t=self.template_contents_json)
        return result
