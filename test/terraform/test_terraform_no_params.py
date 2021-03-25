import unittest
import os
from azure_guardrails.terraform.terraform import TerraformTemplateNoParams
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared.config import get_default_config
from azure_guardrails.shared import utils


class TerraformTemplateNoParamsTestCase(unittest.TestCase):
    def setUp(self) -> None:
        exclude_services = []
        subscription = "example"
        management_group = ""
        enforcement_mode = False
        category = "Testing"

        config = get_default_config(exclude_services=exclude_services)
        # All Services
        self.azure_policies = AzurePolicies(service_names=["all"], config=config)
        self.policy_id_pairs = self.azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=True
        )
        self.terraform_template = TerraformTemplateNoParams(
            policy_id_pairs=self.policy_id_pairs,
            subscription_name=subscription,
            management_group=management_group,
            enforcement_mode=enforcement_mode,
            category=category
        )
        # Key Vault only
        self.kv_azure_policies = AzurePolicies(service_names=["Key Vault"], config=config)
        kv_policy_id_pairs = self.kv_azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=True
        )
        self.kv_terraform_template = TerraformTemplateNoParams(
            policy_id_pairs=kv_policy_id_pairs,
            subscription_name=subscription,
            management_group=management_group,
            enforcement_mode=enforcement_mode,
            category=category
        )

    def test_terraform_key_vault(self):
        self.assertEqual("example_NP_Audit", self.kv_terraform_template.initiative_name)
        print(self.terraform_template.initiative_name)
        self.assertEqual("no_params", self.kv_terraform_template.label)
        print(self.terraform_template.label)
        self.assertEqual("example", self.kv_terraform_template.subscription_name)
        self.assertEqual("", self.kv_terraform_template.management_group)
        policy_id_pairs = self.kv_azure_policies.get_all_policy_ids_sorted_by_service(no_params=True)
        # print(json.dumps(policy_id_pairs, indent=4))
        kv_policy_names = list(policy_id_pairs.get("Key Vault").keys())
        expected_results_file = os.path.join(os.path.dirname(__file__), os.path.pardir, "files", "policy_id_pairs_kv.json")
        expected_results = utils.read_json_file(expected_results_file)
        # print(json.dumps(expected_results, indent=4))
        # print(kv_policy_names)
        for policy_name, policy_details in expected_results["Key Vault"].items():
            self.assertTrue(policy_name in kv_policy_names)

    def test_terraform_name_length(self):
        tmp_terraform_template = TerraformTemplateNoParams(
            policy_id_pairs=self.policy_id_pairs,
            subscription_name="ThisSubscriptionNameIsTooDamnLong",
            management_group="",
            enforcement_mode=False,
            category="Testing"
        )
        print(tmp_terraform_template.initiative_name)
        print(len(tmp_terraform_template.initiative_name))
        self.assertTrue(tmp_terraform_template.initiative_name == "ThisSubscriptio_NP_Audit")
        self.assertTrue(len(tmp_terraform_template.initiative_name) <= 24)

    def test_terraform_name_enforcement_enforce(self):
        tmp_terraform_template = TerraformTemplateNoParams(
            policy_id_pairs=self.policy_id_pairs,
            subscription_name="ThisSubscriptionNameIsTooDamnLong",
            management_group="",
            enforcement_mode=True,
            category="Testing"
        )
        print(tmp_terraform_template.initiative_name)
        print(len(tmp_terraform_template.initiative_name))
        self.assertTrue(tmp_terraform_template.initiative_name == "ThisSubscript_NP_Enforce")
        self.assertTrue(len(tmp_terraform_template.initiative_name) <= 24)
