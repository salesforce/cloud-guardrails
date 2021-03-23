import unittest
import os
import json
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.guardrails.policy_definition import PolicyDefinition


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

    def test_lookup(self):
        policy_id = "73ef9241-5d81-4cd4-b483-8443d1730fe5"
        # Validate metadata is returned as expected
        self.assertTrue(policy_id == self.azure_policies.lookup(policy_property="short_id", policy_id=policy_id))
        self.assertTrue("API Management" == self.azure_policies.lookup(policy_property="service_name", policy_id=policy_id))
        # self.assertTrue("API Management" in self.azure_policies.lookup(policy_property="display_name", policy_id=policy_id))
        print(self.azure_policies.lookup(policy_property="display_name", policy_id=policy_id))
        expected_display_name = "API Management service should use a SKU that supports virtual networks"
        self.assertEqual(expected_display_name, self.azure_policies.lookup(policy_property="display_name", policy_id=policy_id))

        for allowed_effect in ['audit', 'deny', 'disabled']:
            self.assertTrue(allowed_effect in self.azure_policies.lookup(policy_property="allowed_effects", policy_id=policy_id))
        for parameter_name in ['effect', 'listOfAllowedSKUs']:
            self.assertTrue(parameter_name in self.azure_policies.lookup(policy_property="parameter_names", policy_id=policy_id))

        # true/false values
        self.assertFalse(self.azure_policies.lookup(policy_property="no_params", policy_id=policy_id))
        self.assertTrue(self.azure_policies.lookup(policy_property="params_optional", policy_id=policy_id))
        self.assertFalse(self.azure_policies.lookup(policy_property="params_required", policy_id=policy_id))
        self.assertFalse(self.azure_policies.lookup(policy_property="is_deprecated", policy_id=policy_id))
        self.assertFalse(self.azure_policies.lookup(policy_property="audit_only", policy_id=policy_id))
        self.assertFalse(self.azure_policies.lookup(policy_property="modifies_resources", policy_id=policy_id))
        # print(self.azure_policies.lookup(policy_property="allowed_effects", policy_id=policy_id))

    def test_get_policy_definition(self):
        policy_id = "73ef9241-5d81-4cd4-b483-8443d1730fe5"
        policy_definition = self.azure_policies.get_policy_definition(policy_id=policy_id)
        self.assertIsInstance(policy_definition, PolicyDefinition)
        print(policy_definition.short_id)
        # print(type(result))

    def test_get_display_names(self):
        results = self.azure_policies.display_names()
        print(len(results))
        self.assertTrue(len(results) > 400)
        results = self.azure_policies.display_names(service_name="Key Vault")
        self.assertTrue(len(results) > 25)

    def test_get_all_display_names_sorted_by_service(self):
        results = self.azure_policies.get_all_display_names_sorted_by_service()
        print(json.dumps(results, indent=4))

    def test_get_policy_ids_sorted_by_service_with_params(self):
        results = self.azure_policies.get_policy_ids_sorted_by_service_with_params()
        print(json.dumps(results, indent=4))

    def test_get_all_policy_ids_sorted_by_service(self):
        results = self.azure_policies.get_all_policy_ids_sorted_by_service(no_params=True)
        print(json.dumps(results, indent=4))
        api_management_result = results.get("API Management")
        expected_result = {
            "API Management service should use a SKU that supports virtual networks": {
                "short_id": "73ef9241-5d81-4cd4-b483-8443d1730fe5",
                "display_name": "API Management service should use a SKU that supports virtual networks"
            }
        }
        self.assertDictEqual(api_management_result, expected_result)
