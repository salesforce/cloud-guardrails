import os
import json
import unittest
from azure_guardrails.guardrails.properties import Properties
# Params Required
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "AllowedUsersGroups.json"
))
with open(policy_definition_file) as json_file:
    params_required_definition = json.load(json_file)

# Preview definition without the '[Preview]: ' Prefix
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "AzureMonitoring_AddSystemIdentity_Prerequisite.json"
))
with open(policy_definition_file) as json_file:
    weird_preview_definition = json.load(json_file)


class PropertiesTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        self.properties = Properties(properties_json=params_required_definition.get("properties"))
        self.weird_preview_definition_properties = Properties(properties_json=weird_preview_definition.get("properties"))

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
        # print(self.properties.parameter_names)

    def test_parameter_names(self):
        # results = list(self.properties.parameters.keys())
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

    def test_preview_definition_name(self):
        print(self.weird_preview_definition_properties.preview)
        print(self.weird_preview_definition_properties.display_name)
        self.assertTrue('[Preview]: ' not in self.weird_preview_definition_properties.display_name)
