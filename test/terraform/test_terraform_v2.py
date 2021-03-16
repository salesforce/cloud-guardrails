import unittest
from azure_guardrails.terraform.terraform import TerraformParameterV2, TerraformTemplateWithParamsV2


class TerraformParameterV2TestCase(unittest.TestCase):
    def setUp(self) -> None:
        name = "evaluatedSkuNames"
        service = "App Platform"
        policy_definition_name = "Azure Spring Cloud should use network injection"
        initiative_params_json = {
            "evaluatedSkuNames": {
                "name": "evaluatedSkuNames",
                "type": "Array",
                "description": "List of Azure Spring Cloud SKUs against which this policy will be evaluated.",
                "display_name": "Azure Spring Cloud SKU Names",
                "default_value": [
                    "Standard"
                ],
                "allowed_values": [
                    "Standard"
                ]
            }
        }
        default_value = ["Standard"]
        parameter_type = "Array"
        value = None
        self.parameter = TerraformParameterV2(name, service, policy_definition_name, initiative_params_json,
                                              parameter_type, default_value, value)

    def test_terraform_parameter_v2_attributes(self):
        print(self.parameter.name)
        print(self.parameter)
        print(self.parameter)

    def test_policy_assignment_parameter_value(self):
        self.parameter.value = ["Standard"]
        expected_result = 'evaluatedSkuNames = { "value" = ["Standard"] }'
        result = self.parameter.policy_assignment_parameter_value
        self.assertEqual(result, expected_result)


class TerraformTemplateV2TestCase(unittest.TestCase):
    def setUp(self) -> None:
        # the output of Services.get_display_names_sorted_by_service_with_params
        self.kubernetes_parameters = {
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
        subscription_name = "example"
        management_group = ""
        enforcement_mode = False
        self.kubernetes_terraform_template = TerraformTemplateWithParamsV2(
            parameters=self.kubernetes_parameters,
            subscription_name=subscription_name,
            management_group=management_group,
            enforcement_mode=enforcement_mode
        )
        # print(self.terraform_template)
        self.key_vault_parameters = {
            "Key Vault": {
                "Certificates should use allowed key types": {
                    "allowedKeyTypes": {
                        "type": "Array",
                        "metadata": {
                            "displayName": "Allowed key types",
                            "description": "The list of allowed certificate key types."
                        },
                        "allowedValues": [
                            "RSA",
                            "RSA-HSM",
                            "EC",
                            "EC-HSM"
                        ],
                        "defaultValue": [
                            "RSA",
                            "RSA-HSM"
                        ]
                    },
                },
            }
        }
        self.key_vault_terraform_template = TerraformTemplateWithParamsV2(
            parameters=self.key_vault_parameters,
            subscription_name=subscription_name,
            management_group=management_group,
            enforcement_mode=enforcement_mode
        )

    def test_terraform_template_render_key_vault(self):
        results = self.key_vault_terraform_template.rendered()
        print(results)

    def test_terraform_template_render(self):
        # for service_name, policies_with_params in self.terraform_template.policy_definition_reference_parameters()
        results = self.kubernetes_terraform_template.rendered()
        print(results)
