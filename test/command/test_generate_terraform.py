import os
import json
import unittest
from click.testing import CliRunner
from cloud_guardrails.command.generate_terraform import generate_terraform
from cloud_guardrails.shared import utils

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
        args = ["--service", "all", "--subscription", "example", "--no-params", "-n", "--enforce"]
        result = self.runner.invoke(generate_terraform, args)
        print(result.output)
        self.assertTrue(result.exit_code == 0)
        output_file = "no_params.tf"
        self.assertTrue(os.path.exists(output_file))
        contents = utils.read_file(output_file)
        self.assertTrue("Audit VMs that do not use managed disks" in contents)
        # os.remove(output_file)

    def test_generate_terraform_command_with_config(self):
        """command.generate_terraform: with config file that is overly restrictive"""
        args = ["--service", "all", "--subscription", "example", "--no-params", "-n", "--config", default_config_file]
        # with self.assertRaises(Exception):
        result = self.runner.invoke(generate_terraform, args)
        self.assertTrue(result.exit_code == 1)
        self.assertTrue(isinstance(result.exception, Exception))
        # self.assertTrue(result.exit_code == 0)
        #
        # output_file = "no_params.tf"
        # self.assertTrue(os.path.exists(output_file))
        # contents = utils.read_file(output_file)
        # self.assertTrue("private link" in contents)
        # self.assertTrue("encrypt" not in contents)
        # os.remove(output_file)

    def test_generate_terraform_with_explicit_matches(self):
        """command.generate_terraform: with config file that matches keywords"""
        args = ["--service", "all", "--subscription", "example", "--no-params", "-n", "--config", config_with_keyword_matches]
        # with self.assertRaises(Exception):
        result = self.runner.invoke(generate_terraform, args)
        self.assertTrue(result.exit_code == 1)
        self.assertTrue(isinstance(result.exception, Exception))
        print(result)
        # result = self.runner.invoke(generate_terraform, args)
        # print(result.output)
        # We know for sure that no policies that match "customer-managed key" will also
        # contain "private link" in it (which is what the config file above looks for)
        # We also know that by default, there will be a lot of ones that have customer-managed key.
        # It goes to reason that if this works properly, we should not see customer-managed key anywhere.
        # Let's search for it

        # output_file = "no_params.tf"
        # # self.assertTrue(os.path.exists(output_file))
        # contents = utils.read_file(output_file)
        # print(contents)
        # self.assertTrue("customer-managed key" not in contents)
        # # self.assertTrue("private link" in contents)
        # os.remove(output_file)

    def test_generate_terraform_params_optional(self):
        args = ["--service", "all",
                "--subscription", "example",
                "--params-optional"]
        result = self.runner.invoke(generate_terraform, args)
        # print(result.output)
        # We expect that a certain parameter will be in the output. Assert that it exists in the output
        output_file = "params_optional.tf"
        self.assertTrue(os.path.exists(output_file))
        contents = utils.read_file(output_file)
        self.assertTrue("modeRequirement" in contents)
        # os.remove(output_file)

    def test_generate_terraform_params_optional_key_vault(self):
        args = ["--service", "Key Vault",
                "--subscription", "example",
                "--params-optional", "-n"]
        result = self.runner.invoke(generate_terraform, args)
        # print(result.output)
        # We expect that a certain parameter will be in the output. Assert that it exists in the output
        output_file = "params_optional_key vault.tf"
        self.assertTrue(os.path.exists(output_file))
        contents = utils.read_file(output_file)
        self.assertTrue("allowedECNames" in contents)
        os.remove(output_file)

    def test_gh_92_generate_terraform_params_optional_storage_enforce_without_parameters_file(self):
        output_directory = os.path.join(os.path.dirname(__file__), "enforce")
        args = ["--service", "Storage",
                "--subscription", "example",
                "--params-optional", "-n", "--enforce", "-o", output_directory]
        result = self.runner.invoke(generate_terraform, args)
        print(result.output)
        output_file = os.path.join(output_directory, "params_optional_storage.tf")
        # contents = utils.read_file(output_file)

    def test_generate_terraform_params_required(self):
        args = ["--service", "all",
                "--subscription", "example",
                "--params-required", "-n"]
        result = self.runner.invoke(generate_terraform, args)
        output_file = "params_required.tf"
        self.assertTrue(os.path.exists(output_file))
        contents = utils.read_file(output_file)
        expected = "Only approved VM extensions should be installed"
        self.assertTrue(expected in contents)

    def test_generate_terraform_params_required_kubernetes(self):
        args = ["--service", "Kubernetes",
                "--subscription", "example",
                "--params-required", "-n"]
        result = self.runner.invoke(generate_terraform, args)
        # print(result.output)
        # We expect that a certain parameter will be in the output. Assert that it exists in the output
        expected = "Kubernetes cluster should not allow privileged containers"

        output_file = "params_required_kubernetes.tf"
        self.assertTrue(os.path.exists(output_file))
        contents = utils.read_file(output_file)
        self.assertTrue(expected in contents)
        # os.remove(output_file)
