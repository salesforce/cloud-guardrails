import os
import json
import yaml
import unittest
import time
from click.testing import CliRunner
from cloud_guardrails.command.create_parameters_file import create_parameters_file
from cloud_guardrails.shared import utils


class CreateParametersFileTestCase(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_create_parameters_file_with_click(self):
        """command.create_parameters_file: should return exit code 0"""
        result = self.runner.invoke(create_parameters_file, ["--help"])
        print(result.output)
        self.assertTrue(result.exit_code == 0)

    def test_create_optional_parameters_file(self):
        parameters_file = os.path.join(os.path.dirname(__file__), "parameters-optional.yml")
        args = ["-o", parameters_file, "--optional-only"]
        result = self.runner.invoke(create_parameters_file, args)
        # print(result.output)
        self.assertTrue(result.exit_code == 0)
        content = utils.read_yaml_file(parameters_file)
        # os.remove(parameters_file)
        # print(json.dumps(content, indent=4))
        print(json.dumps(content.get("Synapse"), indent=4))
        # These expected results are meant to show the structure as well. There are other services as top level keys.
        # expected_results = {
        #     "Synapse": {
        #         "Auditing on Synapse workspace should be enabled": {
        #             "effect": "AuditIfNotExists",
        #             "setting": "enabled"
        #         }
        #     }
        # }
        self.assertTrue(content["Synapse"]["Auditing on Synapse workspace should be enabled"]["effect"] == "AuditIfNotExists")
        self.assertTrue(content["Synapse"]["Synapse workspace auditing settings should have action groups configured to capture critical activities"]["effect"] == "AuditIfNotExists")
        # self.assertDictEqual(content.get("Synapse"), expected_results.get("Synapse"))

    def test_create_optional_parameters_file_enforce(self):
        parameters_file = os.path.join(os.path.dirname(__file__), "parameters-optional-enforce.yml")
        args = ["-o", parameters_file, "--optional-only", "--enforce"]
        result = self.runner.invoke(create_parameters_file, args)
        self.assertTrue(result.exit_code == 0)
        content = utils.read_yaml_file(parameters_file)
        policy_to_check = content["Storage"]["Storage account public access should be disallowed"]
        print(json.dumps(policy_to_check, indent=4))
        self.assertEqual(policy_to_check["effect"], "deny")

    def test_create_required_parameters_file(self):
        parameters_file = os.path.join(os.path.dirname(__file__), "parameters-required.yml")
        args = ["-o", parameters_file, "--required-only"]
        result = self.runner.invoke(create_parameters_file, args)
        print(result.output)
        self.assertTrue(result.exit_code == 0)
        content = utils.read_yaml_file(parameters_file)
        os.remove(parameters_file)
        # print(json.dumps(content, indent=4))
        # These expected results are meant to show the structure as well. There are other services as top level keys.
        expected_results = {
            "Tags": {
                "Require a tag and its value on resource groups": {
                    "tagName": None,
                    "tagValue": None
                },
                "Require a tag and its value on resources": {
                    "tagName": None,
                    "tagValue": None
                },
                "Require a tag on resource groups": {
                    "tagName": None
                },
                "Require a tag on resources": {
                    "tagName": None
                }
            }
        }
        self.assertDictEqual(content.get("Tags"), expected_results.get("Tags"))

