import os
import yaml
import json
import unittest
from click.testing import CliRunner
from azure_guardrails.command.list_policies import list_policies
from azure_guardrails.shared import utils


class ListPoliciesClickUnitTests(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_list_services_command_with_click_help(self):
        """command.generate_terraform: should return exit code 0"""
        result = self.runner.invoke(list_policies, ["--help"])
        self.assertTrue(result.exit_code == 0)

    def test_list_services_command_with_click_output_stdout(self):
        result = self.runner.invoke(list_policies, ["--service", "Key Vault"])
        self.assertTrue(result.exit_code == 0)
        print(result.output)
        # Ensure that it is not formatted in YAML
        self.assertTrue("Key Vault:" not in result.output)
        # Ensure that it has one of the policy names we expect
        self.assertTrue("Key vaults should have purge protection enabled" in result.output)

    def test_list_services_command_with_click_output_yaml(self):
        result = self.runner.invoke(list_policies, ["--service", "Key Vault", "--format", "yaml"])
        self.assertTrue(result.exit_code == 0)
        print(result.output)
        # Ensure that IS not formatted in YAML, where we expect "Key Vault:" to be one of the keys
        self.assertTrue("Key Vault:" in result.output)
        # Ensure that it has one of the policy names we expect
        yaml_results = yaml.safe_load(result.output)
        print(yaml_results.keys())
        self.assertTrue("Key Vault" in yaml_results.keys())
        self.assertTrue("Key vaults should have purge protection enabled" in yaml_results.get("Key Vault"))

    def test_list_services_command_with_click_with_parameters(self):
        result = self.runner.invoke(list_policies, ["--service", "Kubernetes", "--format", "yaml", "--with-parameters"])
        self.assertTrue(result.exit_code == 0)
        print(result.output)
        # # Ensure that IS not formatted in YAML, where we expect "Key Vault:" to be one of the keys
        # self.assertTrue("Key Vault:" in result.output)
        # # Ensure that it has one of the policy names we expect
        # yaml_results = yaml.safe_load(result.output)
        # print(yaml_results.keys())
        # self.assertTrue("Key Vault" in yaml_results.keys())
        # self.assertTrue("Key vaults should have purge protection enabled" in yaml_results.get("Key Vault"))
        #
