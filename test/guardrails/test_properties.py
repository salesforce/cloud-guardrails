import unittest
import json
import os
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties

policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "AllowedUsersGroups.json"
))
with open(policy_definition_file) as json_file:
    policy_definition_json = json.load(json_file)


class PropertiesTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        # self.policy_json = utils.get_policy_json(service_name="Kubernetes", filename="AllowedUsersGroups.json")
        # self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="Kubernetes")
        self.properties = Properties(properties_json=policy_definition_json.get("properties"))

    def test_properties_attributes(self):
        self.assertEqual(self.properties.display_name, "Kubernetes cluster pods and containers should only run with approved user and group IDs")
        self.assertEqual(self.properties.policy_type, "BuiltIn")
        self.assertEqual(self.properties.mode, "Microsoft.Kubernetes.Data")
        self.assertTrue(self.properties.description.startswith("This policy controls the user,"))
        self.assertEqual(self.properties.version, "2.0.1")
        self.assertEqual(self.properties.category, "Kubernetes")
        self.assertEqual(self.properties.preview, None)
        self.assertEqual(self.properties.deprecated, None)
        self.assertListEqual(list(self.properties.policy_rule.keys()), ["if", "then"])
        print(self.properties.parameter_names)

    def test_parameter_names(self):
        results = self.properties.parameter_names
        expected_results = [
            "effect",
            "excludedNamespaces",
            "namespaces",
            "runAsUserRule",
            "runAsUserRanges",
            "runAsGroupRule",
            "runAsGroupRanges",
            "supplementalGroupsRule",
            "supplementalGroupsRanges",
            "fsGroupRule",
            "fsGroupRanges"
        ]
        print(json.dumps(results, indent=4))
        self.assertListEqual(results, expected_results)
