"""
Writing a specific test file for Github issue #92 because of the wide scope of the issue
https://github.com/salesforce/cloud-guardrails/issues/92
"""

"""
test iam_definition
Validate the get_optional_parameters, get_required_parameters,
get_parameters_by_policy_id
"""

import unittest
import json
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies
from cloud_guardrails.iam_definition.policy_definition import PolicyDefinition
from cloud_guardrails.shared import utils
from click.testing import CliRunner
from cloud_guardrails.command.list_policies import list_policies

disallow_public_blob_access = {
  "properties": {
    "displayName": "Storage account public access should be disallowed",
    "policyType": "BuiltIn",
    "mode": "Indexed",
    "description": "Anonymous public read access to containers and blobs in Azure Storage is a convenient way to share data but might present security risks. To prevent data breaches caused by undesired anonymous access, Microsoft recommends preventing public access to a storage account unless your scenario requires it.",
    "metadata": {
      "version": "2.0.1-preview",
      "category": "Storage",
      "preview": True
    },
    "parameters": {
      "effect": {
        "type": "string",
        "defaultValue": "audit",
        "allowedValues": [
          "audit",
          "deny",
          "disabled"
        ],
        "metadata": {
          "displayName": "Effect",
          "description": "The effect determines what happens when the policy rule is evaluated to match"
        }
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Storage/storageAccounts"
          },
          {
            "field": "id",
            "notContains": "/resourceGroups/databricks-rg-"
          },
          {
            "not": {
              "field":"Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
              "equals": "false"
            }
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  },
  "id": "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751",
  "name": "4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
}

class GH92Parameters(unittest.TestCase):
    def setUp(self) -> None:
        self.azure_policies = AzurePolicies()
        self.runner = CliRunner()

    def test_gh_92_list_policies_storage(self):
        # No params
        result = self.runner.invoke(list_policies, ["--service", "Storage", "--no-params"])
        # print(result.output)
        self.assertTrue(result.output == "")
        # Params optional
        result = self.runner.invoke(list_policies, ["--service", "Storage", "--params-optional"])
        print(result.output)
        self.assertTrue("Storage account public access should be disallowed" in result.output)
        result = self.runner.invoke(list_policies, ["--service", "Storage", "--params-required"])
        print(result.output)

    def test_gh_92_list_policies_container_registry(self):
        # No params
        result = self.runner.invoke(list_policies, ["--service", "Container Registry", "--no-params"])
        # print(result.output)
        print(result.output)
        self.assertTrue(result.output == "")
        # Params optional
        result = self.runner.invoke(list_policies, ["--service", "Container Registry", "--params-optional"])
        # print(result.output)
        self.assertTrue("Container registries should be encrypted with a customer-managed key" in result.output)
        result = self.runner.invoke(list_policies, ["--service", "Container Registry", "--params-required"])
        print(result.output)
        self.assertTrue(result.output == "")

    def test_gh_92_get_parameters_by_policy_id_case_do_NOT_skip_effect(self):
        policy_id = "73ef9241-5d81-4cd4-b483-8443d1730fe5"
        results = self.azure_policies.get_parameters_by_policy_id(policy_id=policy_id)
        print(json.dumps(results, indent=4))
        expected_results = {
            "effect": {
                "name": "effect",
                "type": "String",
                "description": "Enable or disable the execution of the policy",
                "display_name": "Effect",
                "default_value": "Audit",
                "value": "Audit",
                "allowed_values": [
                    "Audit",
                    "Deny",
                    "Disabled"
                ]
            },
            "listOfAllowedSKUs": {
                "name": "listOfAllowedSKUs",
                "type": "Array",
                "description": "The list of SKUs that can be specified for Azure API Management service.",
                "display_name": "Allowed SKUs",
                "default_value": [
                    "Developer",
                    "Premium",
                    "Isolated"
                ],
                "value": [
                    "Developer",
                    "Premium",
                    "Isolated"
                ],
                "allowed_values": [
                    "Developer",
                    "Basic",
                    "Standard",
                    "Premium",
                    "Isolated",
                    "Consumption"
                ]
            }
        }
        self.assertDictEqual(results, expected_results)

class GH92AzurePoliciesTestCase(unittest.TestCase):
    def setUp(self) -> None:
        self.azure_policies = AzurePolicies()

    def test_gh_92_does_optional_parameters_include_effect_policies(self):
        """Validate that get_optional_parameters includes policies that have only one parameter that is 'effect'"""




