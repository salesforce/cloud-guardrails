import unittest
import os
import json
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import PolicyDefinition
from azure_guardrails.guardrails.parameter import Parameter
# Params Required
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "AllowedUsersGroups.json"
))
with open(policy_definition_file) as json_file:
    params_required_definition = json.load(json_file)


class ParameterTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        parameters = params_required_definition.get("properties").get("parameters")
        self.array_parameter = Parameter(name="excludedNamespaces", parameter_json=parameters.get("excludedNamespaces"))

    def test_parameter_attributes(self):
        print("Testing Parameter attributes for Array type")
        self.assertEqual(self.array_parameter.type, "Array")
        self.assertEqual(self.array_parameter.display_name, "Namespace exclusions")
        self.assertEqual(self.array_parameter.description, "List of Kubernetes namespaces to exclude from policy evaluation.")
        self.assertListEqual(self.array_parameter.default_value, ["kube-system", "gatekeeper-system", "azure-arc"])
        self.assertListEqual(list(self.array_parameter.metadata_json.keys()), ["displayName", "description"])
        print(json.dumps(self.array_parameter.json(), indent=4))
        expected_result = {
            "name": "excludedNamespaces",
            "type": "Array",
            "description": "List of Kubernetes namespaces to exclude from policy evaluation.",
            "display_name": "Namespace exclusions",
            "default_value": [
                "kube-system",
                "gatekeeper-system",
                "azure-arc"
            ],
            "value": [
                "kube-system",
                "gatekeeper-system",
                "azure-arc"
            ]
        }
        self.assertDictEqual(self.array_parameter.json(), expected_result)

    def test_parameters_parameter_config(self):
        results = self.array_parameter.parameter_config()
        print(json.dumps(results, indent=4))
        expected_results = {
            "excludedNamespaces": {
                "default_value": [
                    "kube-system",
                    "gatekeeper-system",
                    "azure-arc"
                ],
                "allowed_values": None,
                "type": "Array"
            }
        }
        self.assertDictEqual(results, expected_results)
