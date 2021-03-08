import os
import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.shared.compliance_data import PolicyComplianceData


class PolicyComplianceDataTestCase(unittest.TestCase):
    def setUp(self):
        self.policy_compliance_data = PolicyComplianceData()

    def test_stuff(self):
        # print(json.dumps(self.policy_compliance_data.json(), indent=4))
        # print(self.policy_compliance_data.policy_definition_names())
        print(len(self.policy_compliance_data.policy_definition_names()))
