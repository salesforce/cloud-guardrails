import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.services import Services
import json
import os

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class ServicesTestCase(unittest.TestCase):
    def setUp(self):
        self.service = Services(service_names=["App Platform"])
        self.key_vault_service = Services(service_names=["Key Vault"])
        self.automation_service = Services(service_names=["Automation"])
        self.kubernetes_service = Services(service_names=["Kubernetes"])
        self.all_services = Services(service_names=["all"])

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

    def test_get_display_names_sorted_by_service_no_params(self):
        no_params = self.key_vault_service.get_display_names_sorted_by_service_no_params()
        print(json.dumps(no_params, indent=4))
        expected_results = {
            "Key Vault": [
                "Azure Key Vault Managed HSM should have purge protection enabled",
                "Key vaults should have purge protection enabled",
                "Key vaults should have soft delete enabled",
                "[Preview]: Firewall should be enabled on Key Vault",
                "[Preview]: Key Vault keys should have an expiration date",
                "[Preview]: Key Vault secrets should have an expiration date",
                "[Preview]: Keys should be backed by a hardware security module (HSM)",
                "[Preview]: Private endpoint should be configured for Key Vault",
                "[Preview]: Secrets should have content type set"
            ]
        }
        self.assertDictEqual(no_params, expected_results)

    def test_get_display_names_sorted_by_service_with_params(self):
        # Params Required
        params_required = self.key_vault_service.get_display_names_sorted_by_service_with_params(params_required=True)
        first_params = params_required['Key Vault']['[Preview]: Certificates should be issued by the specified non-integrated certificate authority']
        print(json.dumps(first_params, indent=4))
        expected_results = {
            "caCommonName": {
                "name": "caCommonName",
                "type": "string",
                "description": "The common name (CN) of the Certificate Authority (CA) provider. For example, for an issuer CN = Contoso, OU = .., DC = .., you can specify Contoso",
                "display_name": "The common name of the certificate authority"
            }
        }
        self.assertDictEqual(first_params, expected_results)

        # Params Optional
        params_optional = self.key_vault_service.get_display_names_sorted_by_service_with_params(params_required=False)
        params_optional_keys = list(params_optional.get("Key Vault").keys())
        first_params = params_optional["Key Vault"][params_optional_keys[0]]
        print(json.dumps(first_params, indent=4))
        expected_results = {
            "requiredRetentionDays": {
                "name": "requiredRetentionDays",
                "type": "String",
                "description": "The required resource logs retention in days",
                "display_name": "Required retention (days)",
                "default_value": "365"
            }
        }
        self.assertDictEqual(first_params, expected_results)

    def test_get_all_display_names_sorted_by_service(self):
        results = self.all_services.get_all_display_names_sorted_by_service()
        # print(json.dumps(results, indent=4))
        import yaml
        results = yaml.dump(results)
        print(results)

    def test_services_compliance_coverage(self):
        results = self.all_services.compliance_coverage_data()
        # print(json.dumps(results, indent=4))

    def test_services_table_summary(self):
        results = self.all_services.table_summary(hyperlink_format=False)
        # print(json.dumps(results, indent=4))

    def test_services_csv_summary(self):
        path = os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, os.path.pardir, "all_policies.csv"))
        if os.path.exists(path):
            print("Removing")
            os.remove(path)
        # print(json.dumps(results, indent=4))

    def test_services_markdown_summary(self):
        path = os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, os.path.pardir, "all_policies.md"))
        if os.path.exists(path):
            print("Removing")
            os.remove(path)
        results = self.all_services.markdown_table()
        # print(results)
