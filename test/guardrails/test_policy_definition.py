import unittest
import os
import json
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import PolicyDefinition
from azure_guardrails.shared.iam_definition import skip_display_names

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
    "SqlDBAuditing_Audit.json"
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


class PolicyDefinitionV2TestCase(unittest.TestCase):
    def setUp(self):
        self.no_params_definition = PolicyDefinition(policy_content=no_params_definition, service_name="Automation")
        self.params_optional_definition = PolicyDefinition(policy_content=params_optional_definition, service_name="SQL")
        self.params_required_definition = PolicyDefinition(policy_content=params_required_definition, service_name="Kubernetes")

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
        """PolicyDefinition.no_params"""
        self.assertTrue(self.no_params_definition.no_params)
        self.assertFalse(self.params_optional_definition.no_params)
        self.assertFalse(self.params_required_definition.no_params)

    def test_params_optional(self):
        """PolicyDefinition.params_optional"""
        self.assertFalse(self.no_params_definition.params_optional)
        self.assertTrue(self.params_optional_definition.params_optional)
        self.assertFalse(self.params_required_definition.params_optional)

    def test_params_required(self):
        """PolicyDefinition.params_required"""
        self.assertFalse(self.no_params_definition.params_required)
        self.assertFalse(self.params_optional_definition.params_required)
        self.assertTrue(self.params_required_definition.params_required)

    def test_allowed_effects(self):
        """PolicyDefinition.allowed_effects"""
        self.assertListEqual(self.no_params_definition.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertListEqual(self.params_optional_definition.allowed_effects, ['auditifnotexists', 'disabled'])
        self.assertListEqual(self.params_required_definition.allowed_effects, ['audit', 'deny', 'disabled'])

        # Weird cases
        # We also need to test for some other weird cases, like deployIfNotExists and modify
        # DeployIfNotExists as the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Cosmos DB", filename="CosmosDbAdvancedThreatProtection_Deploy.json")
        self.weird_case = PolicyDefinition(policy_content=weird_case_json, service_name="Cosmos DB")
        self.assertListEqual(self.weird_case.allowed_effects, ['deployifnotexists', 'disabled'])

        # DeployIfNotExists is in the body of the policy definition instead of the "effect" parameter
        # In this case, we have an 'if' statement that greps for deployifnotexists in str(policy_definition.lower())
        weird_case_json = utils.get_policy_json(service_name="Guest Configuration", filename="GuestConfiguration_WindowsCertificateInTrustedRoot_Deploy.json")
        self.weird_case = PolicyDefinition(policy_content=weird_case_json, service_name="Guest Configuration")
        self.assertListEqual(self.weird_case.allowed_effects, ['deployifnotexists'])

        # Modify is in the body of the policy definition instead of the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Monitoring", filename="AzureMonitoring_AddSystemIdentity_Prerequisite.json")
        self.weird_case = PolicyDefinition(policy_content=weird_case_json, service_name="Monitoring")
        self.assertListEqual(self.weird_case.allowed_effects, ['modify'])

        # Append is in the body of the policy definition instead of the "effect" parameter
        weird_case_json = utils.get_policy_json(service_name="Cosmos DB", filename="Cosmos_DisableMetadata_Append.json")
        self.weird_case = PolicyDefinition(policy_content=weird_case_json, service_name="Cosmos DB")
        self.assertListEqual(self.weird_case.allowed_effects, ['append'])

        app_config_json = utils.get_policy_json(service_name="App Configuration", filename="PrivateLink_PublicNetworkAccess_Modify.json")
        self.app_config_case = PolicyDefinition(policy_content=app_config_json, service_name="App Configuration")
        print(self.app_config_case.allowed_effects)
        skip_decision = skip_display_names(self.app_config_case)
        print(skip_decision)

    def test_audit_only(self):
        # Case: Deny, AuditIfNotExists, Disabled
        service = "Container Registry"
        filename = "ACR_CMKEncryptionEnabled_Audit.json"
        policy_json = utils.get_policy_json(service_name=service, filename=filename)
        policy_definition = PolicyDefinition(policy_content=policy_json, service_name=service, file_name=filename)
        print(policy_definition.audit_only)
        print(policy_definition.allowed_effects)
        self.assertFalse(policy_definition.audit_only)

        # Case: AuditIfNotExists, Disabled
        service = "Security Center"
        filename = "ASC_AdaptiveApplicationControls_Audit.json"
        policy_json = utils.get_policy_json(service_name=service, filename=filename)
        policy_definition = PolicyDefinition(policy_content=policy_json, service_name=service, file_name=filename)
        print(policy_definition.audit_only)
        print(policy_definition.allowed_effects)
        self.assertTrue(policy_definition.audit_only)

        # Case: Audit, Disabled
        service = "Security Center"
        filename = "ASC_UpgradeVersion_KubernetesService_Audit.json"
        policy_json = utils.get_policy_json(service_name=service, filename=filename)
        policy_definition = PolicyDefinition(policy_content=policy_json, service_name=service, file_name=filename)
        print(policy_definition.audit_only)
        print(policy_definition.allowed_effects)
        self.assertTrue(policy_definition.audit_only)

        # Case: deployIfNotExists in the policy rule, not the effects parameter
        service = "Security Center"
        filename = "ASC_AzureSecurityLinuxAgent_Deploy.json"
        policy_json = utils.get_policy_json(service_name=service, filename=filename)
        policy_definition = PolicyDefinition(policy_content=policy_json, service_name=service, file_name=filename)
        print(policy_definition.audit_only)
        print(policy_definition.allowed_effects)
        self.assertFalse(policy_definition.audit_only)
