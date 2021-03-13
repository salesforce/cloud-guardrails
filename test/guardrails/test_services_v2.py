import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.guardrails.services_v2 import ServiceV2
import yaml
import ruamel.yaml
import json
import os

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class ServiceV2TestCase(unittest.TestCase):
    def setUp(self):
        self.service = ServiceV2(service_name="App Platform")
        self.key_vault_service = ServiceV2(service_name="Key Vault")

    def test_service_display_names(self):
        expected_files = [
            "Spring_DistributedTracing_Audit.json",
            "Spring_VNETEnabled_Audit.json"
        ]
        # Future proofing this check
        for file in expected_files:
            self.assertTrue(file in self.service.policy_files)

        display_names = self.service.display_names
        expected_results = [
            "[Preview]: Audit Azure Spring Cloud instances where distributed tracing is not enabled",
            "Azure Spring Cloud should use network injection"
        ]
        print(json.dumps(display_names, indent=4))

        display_names = utils.normalize_display_names_list(display_names)
        print(display_names)

        # Future proofing this check
        for result in expected_results:
            self.assertTrue(utils.normalize_display_name_string(result) in display_names)

    def test_service_display_names_no_params(self):
        # App Platform Example
        expected_results = [
            "[Preview]: Audit Azure Spring Cloud instances where distributed tracing is not enabled"
        ]
        self.assertListEqual(self.service.display_names_no_params, expected_results)

        # Key Vault Example
        no_params = utils.normalize_display_names_list(self.key_vault_service.display_names_no_params)
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

    def test_service_display_names_params_optional(self):
        # App Platform Example
        self.assertListEqual(self.service.display_names_params_optional, ['Azure Spring Cloud should use network injection'])

        # Key Vault Example
        params_optional = utils.normalize_display_names_list(self.key_vault_service.display_names_params_optional)
        print(json.dumps(params_optional, indent=4))
        expected_results = [
            "Resource logs in Azure Key Vault Managed HSM should be enabled",
            "Resource logs in Key Vault should be enabled",
            "Certificates should be issued by the specified integrated certificate authority",
            "Certificates should have the specified maximum validity period",
            "Certificates should use allowed key types",
            "Certificates using elliptic curve cryptography should have allowed curve names",
            "Keys should be the specified cryptographic type RSA or EC",
            "Keys using elliptic curve cryptography should have the specified curve names"
        ]
        # Future proof this test
        for expected_result in expected_results:
            self.assertTrue(expected_result in params_optional)


    def test_service_display_names_params_required(self):
        # App Platform Example
        self.assertListEqual(self.service.display_names_params_required, [])

        # Key Vault Example
        params_required = utils.normalize_display_names_list(self.key_vault_service.display_names_params_required)
        print(json.dumps(params_required, indent=4))
        expected_results = [
            "Certificates should be issued by the specified non-integrated certificate authority",
            "Certificates should have the specified lifetime action triggers",
            "Certificates should not expire within the specified number of days",
            "Certificates using RSA cryptography should have the specified minimum key size",
            "Keys should have more than the specified number of days before expiration",
            "Keys should have the specified maximum validity period",
            "Keys should not be active for longer than the specified number of days",
            "Keys using RSA cryptography should have a specified minimum key size",
            "Secrets should have more than the specified number of days before expiration",
            "Secrets should have the specified maximum validity period",
            "Secrets should not be active for longer than the specified number of days"
        ]
        # Future proof this test
        for expected_result in expected_results:
            self.assertTrue(expected_result in params_required)
