import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.guardrails.services import Service, Services


class PolicyDefinitionNoParamsTestCase(unittest.TestCase):
    def setUp(self):
        self.policy_json = utils.get_policy_json(service_name="Automation",
                                                 filename="Automation_AuditUnencryptedVars_Audit.json")
        self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="Automation")

    def test_policy_attributes(self):
        """PolicyDefinition: Attributes for --no-params"""
        self.assertTrue(self.policy_definition.name == "3657f5a0-770e-44a3-b44e-9431ba1e9735")
        self.assertTrue(self.policy_definition.display_name == "Automation account variables should be encrypted")
        self.assertTrue(self.policy_definition.category == "Automation")
        self.assertListEqual(self.policy_definition.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertFalse = self.policy_definition.modifies_resources

    def test_parameter_names(self):
        """PolicyDefinition.parameter_names: For --no-params"""
        expected_results = ['effect']
        results = self.policy_definition.parameter_names
        self.assertListEqual(results, expected_results)

    def test_includes_parameters(self):
        """PolicyDefinition.includes_parameters: For --no-params"""
        results = self.policy_definition.includes_parameters
        self.assertEqual(results, False)

    def test_parameters_have_defaults(self):
        """PolicyDefinition.parameters_have_defaults: For --no-params"""
        results = self.policy_definition.parameters_have_defaults
        print(results)
        # TODO: I am not sure if this makes sense at all, when it is not really True/False, but more like N/A
        self.assertEqual(results, True)


class PolicyDefinitionParamsOptionalTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Auditing on SQL server should be enabled' as a test case"""
        self.policy_json = utils.get_policy_json(service_name="SQL", filename="SqlServerAuditing_Audit.json")
        self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="SQL")

    def test_policy_attributes(self):
        self.assertTrue(self.policy_definition.name == "a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9")
        self.assertTrue(self.policy_definition.display_name == "Auditing on SQL server should be enabled")
        self.assertTrue(self.policy_definition.category == "SQL")
        self.assertListEqual(self.policy_definition.allowed_effects, ['auditifnotexists', 'disabled'])
        self.assertFalse = self.policy_definition.modifies_resources

    def test_parameter_names(self):
        expected_results = ['effect', 'setting']
        results = self.policy_definition.parameter_names
        self.assertListEqual(results, expected_results)

    def test_includes_parameters(self):
        """PolicyDefinition.includes_parameters: For --params-optional"""
        results = self.policy_definition.includes_parameters
        self.assertEqual(results, True)

    def test_parameters_have_defaults(self):
        """PolicyDefinition.parameters_have_defaults: For --params-optional"""
        results = self.policy_definition.parameters_have_defaults
        self.assertEqual(results, True)


class PolicyDefinitionParamsRequiredTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        self.policy_json = utils.get_policy_json(service_name="Kubernetes", filename="AllowedUsersGroups.json")
        self.policy_definition = PolicyDefinition(policy_content=self.policy_json, service_name="Kubernetes")

    def test_policy_attributes(self):
        self.assertTrue(self.policy_definition.name == "f06ddb64-5fa3-4b77-b166-acb36f7f6042")
        self.assertTrue(self.policy_definition.display_name == "Kubernetes cluster pods and containers should only run with approved user and group IDs")
        self.assertTrue(self.policy_definition.category == "Kubernetes")
        self.assertListEqual(self.policy_definition.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertFalse = self.policy_definition.modifies_resources

    def test_parameter_names(self):
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
        results = self.policy_definition.parameter_names
        print(json.dumps(results, indent=4))
        self.assertListEqual(results, expected_results)

    def test_includes_parameters(self):
        """PolicyDefinition.includes_parameters: For --params-optional"""
        results = self.policy_definition.includes_parameters
        self.assertEqual(results, True)

    def test_parameters_have_defaults(self):
        """PolicyDefinition.parameters_have_defaults: For --params-optional"""
        results = self.policy_definition.parameters_have_defaults
        self.assertEqual(results, False)

    def test_modifies_resources(self):
        results = self.policy_definition.modifies_resources
        self.assertEqual(results, False)
