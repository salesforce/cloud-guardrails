import unittest
import os
import json
from azure_guardrails.shared.parameters_config import ParametersConfig, TerraformParameterV4
from azure_guardrails.terraform.terraform_v4 import TerraformTemplateWithParamsV4
from azure_guardrails.terraform.terraform_v5 import TerraformTemplateWithParamsV5
from azure_guardrails.shared.parameters_categorized import OverallCategorizedParameters
from azure_guardrails.shared import utils
from azure_guardrails import set_stream_logger
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared.config import get_default_config, get_config_from_file
import logging


example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    os.path.pardir,
    "examples",
    "parameters-config-example.yml"
))
config = get_default_config(exclude_services=None)


class TerraformTemplateWithParamsV4TestCase(unittest.TestCase):
    def setUp(self) -> None:
        # Let's view the logs
        set_stream_logger("azure_guardrails.shared.parameters_config", level=logging.DEBUG)


        azure_policies = AzurePolicies(service_names=["Kubernetes"], config=config)
        policy_id_pairs = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False, params_optional=True, params_required=True,
            audit_only=False)
        parameter_requirement_str = "PR"
        self.parameters_config = ParametersConfig(
            parameter_config_file=example_config_file,
            params_optional=True,
            params_required=True
        )
        # parameter_requirement_str = "PO"
        self.terraform_template_with_params = TerraformTemplateWithParamsV4(
            policy_id_pairs=policy_id_pairs,
            parameter_requirement_str=parameter_requirement_str,
            parameters_config=self.parameters_config,
            subscription_name="example",
            management_group="",
            enforcement_mode=False,
            category="Testing"
        )

    def test_template_contents_json(self):
        results = self.terraform_template_with_params.template_contents_json
        print(json.dumps(results, indent=4))
        # print(json.dumps(results["policy_definition_reference_parameters"]["Kubernetes"], indent=4))

    def test_terraform_template_with_params_rendered(self):
        results = self.terraform_template_with_params.rendered()
        print(results)


class TerraformTemplateWithParamsV5TestCase(unittest.TestCase):
    def setUp(self) -> None:
        azure_policies = AzurePolicies(service_names=["Kubernetes"], config=config)
        policy_ids_sorted_by_service = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False, params_optional=True, params_required=True,
            audit_only=False)
        parameter_requirement_str = "PR"
        categorized_parameters = OverallCategorizedParameters(azure_policies=azure_policies, params_required=True, params_optional=True, audit_only=False)

        self.terraform_template_with_params = TerraformTemplateWithParamsV5(
            policy_id_pairs=policy_ids_sorted_by_service,
            parameter_requirement_str=parameter_requirement_str,
            categorized_parameters=categorized_parameters,
            subscription_name="example",
            management_group="",
            enforcement_mode=False,
            category="Testing"
        )

    def test_template_contents_json(self):
        results = self.terraform_template_with_params.template_contents_json
        print(json.dumps(results, indent=4))

    def test_template_contents_rendered(self):
        results = self.terraform_template_with_params.rendered()
        print(results)
