import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties


class ParameterRequiredTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        self.policy_json = utils.get_policy_json(service_name="Kubernetes", filename="AllowedUsersGroups.json")
        self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="Kubernetes")
        self.parameters = self.policy_definition.parameter_names
        self.array_parameter = self.policy_definition.properties.get_parameter_by_name("excludedNamespaces")
        # self.string_parameter = self.policy_definition.properties.get_parameter_by_name("runAsUserRule")
        # self.object_parameter = self.policy_definition.properties.get_parameter_by_name("runAsUserRanges")

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
            ]
        }
        self.assertDictEqual(self.array_parameter.json(), expected_result)

# class ParameterOptionalTestCase(unittest.TestCase):
#     def setUp(self):
#         """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
#         self.policy_json = utils.get_policy_json(service_name="Kubernetes", filename="AllowedUsersGroups.json")
#         self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="Kubernetes")
