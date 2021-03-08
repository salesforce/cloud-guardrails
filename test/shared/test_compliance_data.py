import os
import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.shared.compliance_data import PolicyComplianceData, ComplianceCoverage, PolicyDefinitionMetadata, \
    BenchmarkEntry


class PolicyComplianceDataTestCase(unittest.TestCase):
    def setUp(self):
        self.policy_compliance_data = PolicyComplianceData()

    def test_policy_definition_names(self):
        names = self.policy_compliance_data.policy_definition_names()
        self.assertTrue(len(names) >= 300)
        print(json.dumps(names, indent=4))

    def test_get_benchmark_data_matching_policy_definition(self):
        display_name = "A maximum of 3 owners should be designated for your subscription"
        results = self.policy_compliance_data.get_benchmark_data_matching_policy_definition(display_name)
        print(json.dumps(results, indent=4))


class ComplianceCoverageTestCase(unittest.TestCase):
    def test_compliance_coverage_response(self):
        display_names = [
            "Storage accounts should restrict network access using virtual network rules",
            "Storage accounts should use customer-managed key for encryption",
            "[Preview]: Storage account public access should be disallowed",
        ]
        compliance_coverage = ComplianceCoverage(display_names=display_names)
        results = compliance_coverage.matching_metadata
        # print(json.dumps(results, indent=4))
        markdown_table = compliance_coverage.markdown_table()
        print(markdown_table)
        # print(tabulate(results, headers=headers, tablefmt="github"))

    def test_compliance_coverage_response_full(self):
        policy_compliance_data = PolicyComplianceData()
        display_names = policy_compliance_data.policy_definition_names()
        compliance_coverage = ComplianceCoverage(display_names=display_names)
        # results = compliance_coverage.matching_metadata
        # print(json.dumps(results, indent=4))
        markdown_table = compliance_coverage.markdown_table()
        print(markdown_table)
        # print(tabulate(results, headers=headers, tablefmt="github"))
