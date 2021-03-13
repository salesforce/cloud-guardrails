import unittest
import os
import json
from azure_guardrails.shared import utils
# from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.guardrails.policy_definition_v2 import PolicyDefinitionV2, PropertiesV2, ParameterV2

# No Params
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "Automation_AuditUnencryptedVars_Audit.json"
))
with open(policy_definition_file) as json_file:
    no_params_definition = json.load(json_file)

# Params Optional
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "SQLDBAuditing_Audit.json"
))
with open(policy_definition_file) as json_file:
    params_optional_definition = json.load(json_file)

# Params Required
policy_definition_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.pardir,
    "files",
    "AllowedUsersGroups.json"
))
with open(policy_definition_file) as json_file:
    params_required_definition = json.load(json_file)


class PropertiesTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        self.properties = PropertiesV2(properties_json=params_required_definition.get("properties"))

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


class ParameterTestCase(unittest.TestCase):
    def setUp(self):
        """Use 'Kubernetes cluster pods and containers should only run with approved user and group IDs'"""
        parameters = params_required_definition.get("properties").get("parameters")
        self.array_parameter = ParameterV2(name="excludedNamespaces", parameter_json=parameters.get("excludedNamespaces"))

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


class PolicyDefinitionV2TestCase(unittest.TestCase):
    def setUp(self):
        self.no_params_definition = PolicyDefinitionV2(policy_content=no_params_definition, service_name="Automation")
        self.params_optional_definition = PolicyDefinitionV2(policy_content=params_optional_definition, service_name="SQL")
        self.params_required_definition = PolicyDefinitionV2(policy_content=params_required_definition, service_name="Kubernetes")

    def test_policy_attributes(self):
        """PolicyDefinition: Attributes for --no-params"""
        self.assertTrue(self.no_params_definition.name == "3657f5a0-770e-44a3-b44e-9431ba1e9735")
        self.assertTrue(self.no_params_definition.display_name == "Automation account variables should be encrypted")
        self.assertTrue(self.no_params_definition.category == "Automation")
        # self.assertListEqual(self.policy_definition.allowed_effects, ['audit', 'deny', 'disabled'])
        # self.assertFalse = self.policy_definition.modifies_resources

    def test_parameter_names(self):
        # No Params
        self.assertListEqual(self.no_params_definition.parameter_names, ["effect"])
        # Params Required
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
        self.assertListEqual(self.params_required_definition.parameter_names, expected_results)

    def test_no_params(self):
        """PolicyDefinitionV2.no_params"""
        self.assertTrue(self.no_params_definition.no_params)
        self.assertFalse(self.params_optional_definition.no_params)
        self.assertFalse(self.params_required_definition.no_params)

    def test_params_optional(self):
        """PolicyDefinitionV2.params_optional"""
        self.assertFalse(self.no_params_definition.params_optional)
        self.assertTrue(self.params_optional_definition.params_optional)
        self.assertFalse(self.params_required_definition.params_optional)

    def test_params_required(self):
        """PolicyDefinitionV2.params_required"""
        self.assertFalse(self.no_params_definition.params_required)
        self.assertFalse(self.params_optional_definition.params_required)
        self.assertTrue(self.params_required_definition.params_required)

    def test_allowed_effects(self):
        """PolicyDefinitionV2.allowed_effects"""
        self.assertListEqual(self.no_params_definition.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertListEqual(self.params_optional_definition.allowed_effects, ['auditifnotexists', 'disabled'])
        self.assertListEqual(self.params_required_definition.allowed_effects, ['audit', 'deny', 'disabled'])

        # Weird cases
        # We also need to test for some other weird cases, like deployIfNotExists and modify
        # DeployIfNotExists as the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Cosmos DB", filename="CosmosDbAdvancedThreatProtection_Deploy.json")
        self.weird_case = PolicyDefinitionV2(policy_content=weird_case_json, service_name="Cosmos DB")
        self.assertListEqual(self.weird_case.allowed_effects, ['deployifnotexists', 'disabled'])

        # DeployIfNotExists is in the body of the policy definition instead of the "effect" parameter
        # In this case, we have an 'if' statement that greps for deployifnotexists in str(policy_definition.lower())
        weird_case_json = utils.get_policy_json(service_name="Guest Configuration", filename="GuestConfiguration_WindowsCertificateInTrustedRoot_Deploy.json")
        self.weird_case = PolicyDefinitionV2(policy_content=weird_case_json, service_name="Guest Configuration")
        self.assertListEqual(self.weird_case.allowed_effects, ['deployifnotexists'])

        # Modify is in the body of the policy definition instead of the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Monitoring", filename="AzureMonitoring_AddSystemIdentity_Prerequisite.json")
        self.weird_case = PolicyDefinitionV2(policy_content=weird_case_json, service_name="Monitoring")
        self.assertListEqual(self.weird_case.allowed_effects, ['modify'])

        # Append is in the body of the policy definition instead of the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Cosmos DB", filename="Cosmos_DisableMetadata_Append.json")
        self.weird_case = PolicyDefinitionV2(policy_content=weird_case_json, service_name="Cosmos DB")
        self.assertListEqual(self.weird_case.allowed_effects, ['append'])
