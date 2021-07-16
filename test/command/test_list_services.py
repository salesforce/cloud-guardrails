import os
import json
import unittest
from click.testing import CliRunner
from cloud_guardrails.command.list_services import list_services
from cloud_guardrails.shared import utils


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
