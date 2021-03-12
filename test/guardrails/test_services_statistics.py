import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.policy_definition import Parameter, PolicyDefinition, Properties
from azure_guardrails.guardrails.services import Service, Services
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

        results = services.get_display_names(all_policies=True)
        print(f"All Policies: {len(results)}")
        self.assertTrue(len(results) >= 471)

        results = services.get_display_names()
        print(f"No parameters or modification: {len(results)}")
        self.assertTrue(len(results) >= 262)

        results = services.get_display_names(with_parameters=True)
        print(f"With Parameters only: {len(results)}")
        self.assertTrue(len(results) >= 176)

        results = services.get_display_names(with_parameters=False, with_modify_capabilities=True)
        print(f"With Modify capabilities only: {len(results)}")
        self.assertTrue(len(results) >= 0)

        results = services.get_display_names(with_parameters=True, with_modify_capabilities=True)
        print(f"With Modify capabilities and Parameters only: {len(results)}")
        self.assertTrue(len(results) >= 68)

    def test_get_display_names_by_service_with_parameters(self):
        results = self.services.get_display_names_sorted_by_service(with_parameters=True)
        print(json.dumps(results, indent=4))
