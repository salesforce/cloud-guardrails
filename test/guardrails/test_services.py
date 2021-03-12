import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.guardrails.services import Service, Services
import yaml
import ruamel.yaml
import json
import os

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class ServiceTestCase(unittest.TestCase):
    def setUp(self):
        self.services = Services()
        self.services_key_vault = Services(service_names=["Key Vault"])

    def test_get_display_names_no_params(self):
        results = self.services.get_display_names(with_parameters=False)
        self.assertTrue(len(results) >= 262)
        key_vault_results = self.services_key_vault.get_display_names(with_parameters=False)
        print(len(key_vault_results))
        self.assertTrue(len(key_vault_results) >= 9)

    def test_get_display_names_sorted_by_service_no_params(self):
        results = self.services_key_vault.get_display_names_sorted_by_service(with_parameters=False)
        key_vault_results = results.get("Key Vault")
        print(len(key_vault_results))
        self.assertTrue(len(key_vault_results) >= 9)

    def test_get_display_names_with_params(self):
        results = self.services.get_display_names(with_parameters=True)
        print(len(results))
        self.assertTrue(len(results) >= 176)
        results = self.services_key_vault.get_display_names_sorted_by_service(with_parameters=True)
        key_vault_results = results.get("Key Vault")
        print(len(key_vault_results))
        self.assertTrue(len(key_vault_results) >= 19)
        print(json.dumps(key_vault_results, indent=4))
        self.assertTrue("Resource logs in Key Vault should be enabled" in key_vault_results)

    def test_get_display_names_by_service_with_parameters(self):

        results = self.services_key_vault.get_display_names_by_service_with_parameters(include_empty_defaults=True)
        key_vault_results = results.get("Key Vault")
        """
        Looks like this:
        
        {
            "Resource logs in Azure Key Vault Managed HSM should be enabled": {
                "requiredRetentionDays": {
                    "name": "requiredRetentionDays",
                    "type": "String",
                    "description": "The required resource logs retention in days",
                    "display_name": "Required retention (days)",
                    "default_value": "365"
                }
            },
            "Resource logs in Key Vault should be enabled": {
                "requiredRetentionDays": {
                    "name": "requiredRetentionDays",
                    "type": "String",
                    "description": "The required resource logs retention in days",
                    "display_name": "Required retention (days)",
                    "default_value": "365"
                }
            }
            ..
        }
        """
        print(json.dumps(key_vault_results, indent=4))
        self.assertTrue("Resource logs in Key Vault should be enabled" in key_vault_results.keys())
        results = self.services_key_vault.get_display_names_by_service_with_parameters(include_empty_defaults=False)
        key_vault_results = results.get("Key Vault")
        print(json.dumps(key_vault_results, indent=4))
