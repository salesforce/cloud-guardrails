import unittest
import os
import json
from azure_guardrails.terraform.terraform_with_params import TerraformTemplateWithParams, get_placeholder_value_given_type
from azure_guardrails.shared.parameters_categorized import CategorizedParameters
from azure_guardrails.iam_definition.azure_policies import AzurePolicies
from azure_guardrails.shared.config import get_default_config

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    os.path.pardir,
    "examples",
    "parameters-config-example.yml"
))
config = get_default_config(exclude_services=None)


class TerraformTemplateWithParamsV5TestCase(unittest.TestCase):
    def setUp(self) -> None:
        azure_policies = AzurePolicies(service_names=["Kubernetes"], config=config)
        policy_ids_sorted_by_service = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False, params_optional=True, params_required=True,
            audit_only=False)
        parameter_requirement_str = "PR"
        categorized_parameters = CategorizedParameters(
            azure_policies=azure_policies,
            params_required=True,
            params_optional=True,
            audit_only=False
        )

        self.terraform_template_with_params = TerraformTemplateWithParams(
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
        # print(results)

    def test_get_placeholder_value_given_type(self):
        results = get_placeholder_value_given_type("array")
        self.assertListEqual(results, [])
        self.assertEqual(get_placeholder_value_given_type("string"), '""')
        self.assertDictEqual(get_placeholder_value_given_type("object"), {})
