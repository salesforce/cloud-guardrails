import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.services import Services
import yaml
import ruamel.yaml
import json
import os

example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "service-parameters-template.yml"
))


class ServiceStatisticsTestCase(unittest.TestCase):
    def setUp(self):
        # self.policy_json = utils.get_policy_json(service_name="Automation", filename="Automation_AuditUnencryptedVars_Audit.json")
        self.services = Services()

    def test_services(self):
        services = Services()
        # print(f"Service Names: {', '.join(services.service_names)}")

        results = services.display_names_no_params
        print(f"No parameters or modification: {len(results)}")
        self.assertTrue(len(results) >= 275)

        results = services.display_names_params_optional
        print(f"Params Optional: {len(results)}")
        self.assertTrue(len(results) >= 80)

        results = services.display_names_params_required
        print(f"Params Required: {len(results)}")
        self.assertTrue(len(results) >= 92)
