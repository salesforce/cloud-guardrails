import unittest
import os
import json
from azure_guardrails.shared.iam_definition import AzurePolicies


class IamDefinitionTestCase(unittest.TestCase):
    def setUp(self) -> None:
        self.azure_policies = AzurePolicies()

    def test_policy_ids(self):
        # print(self.azure_policies.policy_ids())
        print(len(self.azure_policies.policy_ids()))
        # Length of all policies is expected to be 800+
        self.assertTrue(len(self.azure_policies.policy_ids()) > 800)

        # Key Vault Policies should be greater than 25
        key_vault_policies = self.azure_policies.policy_ids(service_name="Key Vault")
        print(len(key_vault_policies))
        self.assertTrue(len(key_vault_policies) > 25)
