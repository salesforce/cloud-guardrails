import unittest
import os
import json
from cloud_guardrails.shared.parameters_categorized import CategorizedParameters
from cloud_guardrails.shared import utils
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies

parameters_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    os.path.pardir,
    "examples",
    "parameters-config-example.yml"
))
parameters_config = utils.read_yaml_file(parameters_config_file)


class ParametersCategorizedTestCase(unittest.TestCase):
    def setUp(self) -> None:
        azure_policies = AzurePolicies(service_names=["Batch"])
        self.policy_ids_sorted_by_service = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=False, params_optional=True, params_required=True,
            audit_only=False)
        self.categorized_parameters = CategorizedParameters(
            azure_policies=azure_policies,
            parameters_config=parameters_config,
            params_required=True,
            params_optional=True,
            audit_only=False
        )

    def test_validate_parameters_config(self):
        results = self.categorized_parameters.parameters_config
        print(json.dumps(results, indent=4))
        expected_results = {
            "API Management": {
                "API Management service should use a SKU that supports virtual networks": {
                    "effect": "Deny",
                    "listOfAllowedSKUs": [
                        "Developer",
                        "Premium",
                        "Isolated"
                    ]
                }
            },
            "Kubernetes": {
                "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {},
                    "cpuLimit": "200m",
                    "memoryLimit": "1Gi"
                },
                "Kubernetes cluster containers should not share host process ID or host IPC namespace": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {}
                },
                "Kubernetes cluster containers should not use forbidden sysctl interfaces": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {},
                    "forbiddenSysctls": []
                }
            }
        }
        self.assertDictEqual(results, expected_results)

    def test_parameter_config_output(self):
        results = self.categorized_parameters.service_categorized_parameters
        print(json.dumps(results, indent=4))
