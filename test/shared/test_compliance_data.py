import os
import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.scrapers.compliance_data import PolicyComplianceData, ComplianceCoverage, PolicyDefinitionMetadata, \
    BenchmarkEntry
import unittest
from azure_guardrails.shared import utils
from azure_guardrails.guardrails.services import ServicesV2, Service
from azure_guardrails.scrapers.compliance_data import ComplianceCoverage
from azure_guardrails.shared.config import get_default_config, get_config_from_file


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
        # print(json.dumps(results, indent=4))


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
        # print(markdown_table)
        # print(tabulate(results, headers=headers, tablefmt="github"))

    def test_compliance_coverage_response_full(self):
        policy_compliance_data = PolicyComplianceData()
        display_names = policy_compliance_data.policy_definition_names()
        compliance_coverage = ComplianceCoverage(display_names=display_names)
        # results = compliance_coverage.matching_metadata
        # print(json.dumps(results, indent=4))
        markdown_table = compliance_coverage.markdown_table()
        # print(markdown_table)
        # print(tabulate(results, headers=headers, tablefmt="github"))


# class OtherComplianceCoverageTestCase(unittest.TestCase):
#     def setUp(self):
#         service = "all"
#         config = get_default_config(exclude_services=None)
#         with_parameters = False
#         if service == "all":
#             self.services = ServicesV2(config=config)
#             self.policy_names = self.services.di
#         else:
#             self.services = Service(service_name=service, config=config)
#             self.policy_names = self.services.get_display_names(with_parameters=with_parameters)
#         self.compliance_coverage = ComplianceCoverage(display_names=self.policy_names)
#
#     def test_markdown_table(self):
#         markdown_table = self.compliance_coverage.markdown_table()
#         summary = self.compliance_coverage.table_summary()
#         print(markdown_table)

    # def test_csv_table(self):
    #     path = os.path.join(
    #         os.path.pardir,
    #         os.path.pardir,
    #         "test.csv"
    #     )
    #     if os.path.exists(path):
    #         print("Removing the previous file")
    #         os.remove(path)
    #     self.compliance_coverage.csv_table(path, verbosity=0)
    #     print(f"CSV updated! Path: {path}")

