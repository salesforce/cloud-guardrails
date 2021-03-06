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
default_exclusions_file = os.path.join(test_files_directory, "example-exclusions.yml")
exclusions_with_keyword_matches = os.path.join(test_files_directory, "exclusions-match-keywords.yml")


class GenerateTerraformClickUnitTests(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_generate_terraform_command_with_click(self):
        """command.generate_terraform: should return exit code 0"""
        result = self.runner.invoke(generate_terraform, ["--help"])
        self.assertTrue(result.exit_code == 0)
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--quiet"])
        self.assertTrue(result.exit_code == 0)

    def test_generate_terraform_command_with_exclusions(self):
        """command.generate_terraform: with exclusions file"""
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--exclusions-file", default_exclusions_file])
        self.assertTrue(result.exit_code == 0)
        print(result.output)

    def test_generate_terraform_with_explicit_matches(self):
        """command.generate_terraform: with exclusions file that matches keywords"""
        result = self.runner.invoke(generate_terraform, ["--service", "all", "--exclusions-file", exclusions_with_keyword_matches])
        # print(result.output)
        # We know for sure that no policies that match "customer-managed key" will also
        # contain "private link" in it (which is what the exclusions file above looks for)
        # We also know that by default, there will be a lot of ones that have customer-managed key.
        # It goes to reason that if this works properly, we should not see customer-managed key anywhere.
        # Let's search for it
        self.assertTrue("customer-managed key" not in result.output)
        self.assertTrue("private link" in result.output)
