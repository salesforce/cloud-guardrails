import unittest
from azure_guardrails.shared import utils
from azure_guardrails.logic.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.logic.services import Service, Services


class CommonTestCase(unittest.TestCase):
    def setUp(self):
        self.policy_json = utils.get_policy_json(service_name="Automation", filename="Automation_AuditUnencryptedVars_Audit.json")

    def test_policy_loading(self):
        policy = PolicyDefinition(policy_content=self.policy_json)
        self.assertTrue(policy.name == "3657f5a0-770e-44a3-b44e-9431ba1e9735")
        self.assertTrue(policy.display_name == "Automation account variables should be encrypted")
        self.assertTrue(policy.category == "Automation")
        self.assertListEqual(policy.allowed_effects, ['audit', 'deny', 'disabled'])
        self.assertFalse = policy.modifies_resources

    def test_services(self):
        services = Services()
        # print(f"Service Names: {', '.join(services.service_names)}")

        display_names = services.get_display_names(all_policies=True)
        print(f"All Policies: {len(display_names)}")

        display_names = services.get_display_names()
        print(f"No parameters or modification: {len(display_names)}")

        display_names = services.get_display_names(with_parameters=True)
        print(f"With Parameters only: {len(display_names)}")

        display_names = services.get_display_names(with_parameters=False, with_modify_capabilities=True)
        print(f"With Modify capabilities only: {len(display_names)}")

        display_names = services.get_display_names(with_parameters=True, with_modify_capabilities=True)
        print(f"With Modify capabilities and Parameters only: {len(display_names)}")

