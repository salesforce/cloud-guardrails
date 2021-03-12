import os
import json
import unittest
from click.testing import CliRunner
from azure_guardrails.command.list_services import list_services
from azure_guardrails.shared import utils

test_files_directory = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    "files",
))
default_config_file = os.path.join(test_files_directory, "example-config.yml")
config_with_keyword_matches = os.path.join(test_files_directory, "config-match-keywords.yml")


class ListServicesClickUnitTests(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_list_services_command_with_click_help(self):
        """command.generate_terraform: should return exit code 0"""
        result = self.runner.invoke(list_services, ["--help"])
        self.assertTrue(result.exit_code == 0)

    def test_list_services_command_with_click_output(self):
        result = self.runner.invoke(list_services)
        self.assertTrue(result.exit_code == 0)
        print(result.output)
        expected_services = utils.get_service_names()
        for service in expected_services:
            self.assertTrue(service in result.output)
