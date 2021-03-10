import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.terraform.terraform import get_terraform_template, TerraformTemplate
from azure_guardrails.guardrails.services import Services, Service


class TerraformTestCase(unittest.TestCase):
    def test_terraform_single_service(self):
        service = Service(service_name="Key Vault")
        policy_names = service.get_display_names_sorted_by_service(with_parameters=False)
        policy_set_name = "test"
        subscription_name = "example-subscription"
        management_group = ""
        enforcement_mode = False
        result = get_terraform_template(name=policy_set_name, policy_names=policy_names,
                                        subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
        # print(result)

    def test_terraform_all_services(self):
        services = Services()
        policy_set_name = "test"
        subscription_name = "example-subscription"
        management_group = ""
        enforcement_mode = False
        display_names = services.get_display_names_sorted_by_service(with_parameters=False)
        result = get_terraform_template(name=policy_set_name, policy_names=display_names,
                                        subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
        # print(result)

class TerraformTemplateClassTestCase(unittest.TestCase):
    def setUp(self):
        self.example_parameters = {
            "Kubernetes": {
                "Do not allow privileged containers in Kubernetes cluster": {
                    "excludedNamespaces": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Namespace exclusions",
                            "description": "List of Kubernetes namespaces to exclude from policy evaluation."
                        },
                        "defaultValue": ["kube-system", "gatekeeper-system", "azure-arc"]
                    },
                    "namespaces": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Namespace inclusions",
                            "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
                        },
                        "defaultValue": []
                    }
                },
                "Kubernetes cluster containers should only use allowed capabilities": {
                    "excludedNamespaces": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Namespace exclusions",
                            "description": "List of Kubernetes namespaces to exclude from policy evaluation."
                        },
                        "defaultValue": ["kube-system", "gatekeeper-system", "azure-arc"]
                    },
                    "namespaces": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Namespace inclusions",
                            "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
                        },
                        "defaultValue": []
                    },
                    "allowedCapabilities": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Allowed capabilities",
                            "description": "The list of capabilities that are allowed to be added to a container. Provide empty list as input to block everything."
                        },
                        "defaultValue": []
                    },
                    "requiredDropCapabilities": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Required drop capabilities",
                            "description": "The list of capabilities that must be dropped by a container."
                        },
                        "defaultValue": []
                    }
                }
            }
        }
        self.terraform_template = TerraformTemplate(name="example", parameters=self.example_parameters, subscription_name="example")

    def test_get_policy_parameters(self):
        results = self.terraform_template.get_policy_parameters("Kubernetes", "Kubernetes cluster containers should only use allowed capabilities")
        # print(json.dumps(results, indent=4))
        # print(json.dumps(list(results.keys()), indent=4))
        parameters = list(results.keys())
        expected_parameters = [
            "excludedNamespaces",
            "namespaces",
            "allowedCapabilities",
            "requiredDropCapabilities"
        ]
        # print(terraform_template.service_parameters)
        self.assertListEqual(parameters, expected_parameters)

    def test_policy_names(self):
        expected_policy_list = [
            'Do not allow privileged containers in Kubernetes cluster',
            'Kubernetes cluster containers should only use allowed capabilities'
        ]
        # print(terraform_template.policy_names())
        self.assertListEqual(self.terraform_template.policy_names(), expected_policy_list)

    def test_all_parameters(self):
        expected_parameters = [
            "excludedNamespaces",
            "namespaces",
            "allowedCapabilities",
            "requiredDropCapabilities"
        ]
        results = self.terraform_template.all_parameters()
        print(json.dumps(results, indent=4))
        self.assertListEqual(list(results.keys()), expected_parameters)

    def test_policy_definition_reference_parameters(self):
        expected_results = {
            'Do not allow privileged containers in Kubernetes cluster': ['excludedNamespaces', 'namespaces'],
            'Kubernetes cluster containers should only use allowed capabilities': ['excludedNamespaces', 'namespaces', 'allowedCapabilities', 'requiredDropCapabilities']
        }
        print(self.terraform_template.policy_definition_reference_parameters())
        self.assertDictEqual(self.terraform_template.policy_definition_reference_parameters(), expected_results)

    def test_terraform_template_render(self):
        # for service_name, policies_with_params in self.terraform_template.policy_definition_reference_parameters()
        results = self.terraform_template.rendered()
        print(results)
