import os
import json
import yaml
import unittest
import time
from click.testing import CliRunner
from azure_guardrails.command.describe_policy import describe_policy
from azure_guardrails.shared import utils


class DescribePolicyTestCase(unittest.TestCase):
    def setUp(self):
        self.runner = CliRunner()

    def test_describe_policy_with_click(self):
        """command.describe_policy: should return exit code 0"""
        result = self.runner.invoke(describe_policy, ["--help"])
        print(result.output)
        self.assertTrue(result.exit_code == 0)

    def test_describe_policy_output_by_display_name(self):
        display_name = "Service Bus Premium namespaces should use a customer-managed key for encryption"
        args = ["--name", display_name]
        result = self.runner.invoke(describe_policy, args)
        print(result.output)
        self.assertTrue("295fc8b1-dc9f-4f53-9c61-3f313ceab40a" in result.output)

    def test_describe_policy_output_by_id(self):
        args = ["--id", "295fc8b1-dc9f-4f53-9c61-3f313ceab40a"]
        result = self.runner.invoke(describe_policy, args)
        print(result.output)
        # GH #60 - describe-policy should output the GitHub link
        self.assertTrue("github.com" in result.output)


