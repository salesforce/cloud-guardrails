import os
import json
import unittest
from click.testing import CliRunner
from azure_guardrails.command.generate_terraform import generate_terraform

test_files_directory = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    "files",
))
default_config_file = os.path.join(test_files_directory, "example-config.yml")
config_with_keyword_matches = os.path.join(test_files_directory, "config-match-keywords.yml")


class GenerateTerraformClickUnitTests(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_generate_terraform_command_with_click(self):
        """command.generate_terraform: should return exit code 0"""
        result = self.runner.invoke(generate_terraform, ["--help"])
        self.assertTrue(result.exit_code == 0)
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--subscription", "example"])
        # print(result.output)
        self.assertTrue(result.exit_code == 0)

    def test_generate_terraform_command_with_config(self):
        """command.generate_terraform: with config file"""
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--subscription", "example", "--config-file", default_config_file])
        self.assertTrue(result.exit_code == 0)
        # print(result.output)

    def test_generate_terraform_with_explicit_matches(self):
        """command.generate_terraform: with config file that matches keywords"""
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--subscription", "example", "--config-file", config_with_keyword_matches])
        # print(result.output)
        # We know for sure that no policies that match "customer-managed key" will also
        # contain "private link" in it (which is what the config file above looks for)
        # We also know that by default, there will be a lot of ones that have customer-managed key.
        # It goes to reason that if this works properly, we should not see customer-managed key anywhere.
        # Let's search for it
        self.assertTrue("customer-managed key" not in result.output)
        self.assertTrue("private link" in result.output)
