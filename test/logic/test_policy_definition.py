import unittest
from azure_guardrails.shared import utils
from azure_guardrails.logic.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.logic.services import Service, Services


class PolicyDefinitionTestCase(unittest.TestCase):
    def setUp(self):
        self.policy_json = utils.get_policy_json(service_name="Automation", filename="Automation_AuditUnencryptedVars_Audit.json")

    def test_policy_loading(self):
        policy = PolicyDefinition(policy_content=self.policy_json)
        self.assertTrue(policy.name == "3657f5a0-770e-44a3-b44e-9431ba1e9735")
        self.assertTrue(policy.display_name == "Automation account variables should be encrypted")
        self.assertTrue(policy.category == "Automation")
        self.assertListEqual(policy.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertFalse = policy.modifies_resources
