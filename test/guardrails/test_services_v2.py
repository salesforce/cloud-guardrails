import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.services_v2 import ServicesV2
import json
import os

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class ServicesV2TestCase(unittest.TestCase):
    def setUp(self):
        self.service = ServicesV2(service_names=["App Platform"])
        self.key_vault_service = ServicesV2(service_names=["Key Vault"])
        self.automation_service = ServicesV2(service_names=["Automation"])
        self.kubernetes_service = ServicesV2(service_names=["Kubernetes"])
        self.all_services = ServicesV2(service_names=["all"])

    def test_display_names_no_params(self):
        """Services.display_names_no_params"""
        # App Platform Example
        no_params = self.service.display_names_no_params
        no_params = utils.normalize_display_names_list(no_params)
        print(json.dumps(no_params, indent=4))
        expected_results = [
            "Audit Azure Spring Cloud instances where distributed tracing is not enabled"
        ]
        # Future proof this test
        for expected_result in expected_results:
            self.assertTrue(expected_result in no_params)

        # Key Vault Example
        no_params = self.key_vault_service.display_names_no_params
        no_params = utils.normalize_display_names_list(no_params)
        print(json.dumps(no_params, indent=4))
        expected_results = [
            "Azure Key Vault Managed HSM should have purge protection enabled",
            "Key vaults should have purge protection enabled",
            "Key vaults should have soft delete enabled",
            "Firewall should be enabled on Key Vault",
            "Key Vault keys should have an expiration date",
            "Key Vault secrets should have an expiration date",
            "Keys should be backed by a hardware security module (HSM)",
            "Private endpoint should be configured for Key Vault",
            "Secrets should have content type set"
        ]
        # Future proof this test
        for expected_result in expected_results:
            self.assertTrue(expected_result in no_params)

    def test_display_names_params_optional(self):
        """Services.display_names_no_params"""
        params_optional = self.key_vault_service.display_names_params_optional
        params_optional = utils.normalize_display_names_list(params_optional)
        print(json.dumps(params_optional, indent=4))
        self.assertTrue(len(params_optional) >= 8)

    def test_display_names_params_required(self):
        """Services.display_names_no_params"""
        params_required = self.kubernetes_service.display_names_params_required
        params_required = utils.normalize_display_names_list(params_required)
        print(f"Params Required: {len(params_required)}")
        # print(json.dumps(params_required, indent=4))
        self.assertTrue(len(params_required) >= 28)

        params_optional = self.kubernetes_service.display_names_params_optional
        print(f"Params Optional: {len(params_optional)}")
        self.assertTrue(len(params_optional) == 0)

        no_params = self.kubernetes_service.display_names_no_params
        print(f"No Params: {len(no_params)}")
        self.assertTrue(len(no_params) >= 3)
