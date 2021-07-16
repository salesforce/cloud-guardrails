import unittest
import json
from cloud_guardrails.shared.config import get_default_config
from cloud_guardrails.terraform.guardrails import TerraformGuardrails


class AzurePoliciesTestCase(unittest.TestCase):
    def setUp(self) -> None:
        config = get_default_config(exclude_services=[])
        self.terraform = TerraformGuardrails(
            service="Key Vault",
            config=config,
            subscription="example",
            management_group="",
            parameters_config={},
            no_params=True,
            params_optional=False,
            params_required=False,
            category="Testing",
            enforcement_mode=True,
            verbosity=3
        )

    def test_policy_metadata(self):
        policy_id_pairs = self.terraform.policy_id_pairs()
        print(json.dumps(policy_id_pairs, indent=4))
        policy_names = self.terraform.policy_names()
        print(json.dumps(policy_names, indent=4))
        policy_ids = self.terraform.policy_ids()
        print(json.dumps(policy_ids, indent=4))
        self.assertTrue(len(policy_names) == len(policy_ids))

