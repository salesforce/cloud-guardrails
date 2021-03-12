import unittest
from azure_guardrails.shared import utils
from azure_guardrails.scrapers.compliance_data import ComplianceCoverage
from azure_guardrails.guardrails.services import Services, Service
from azure_guardrails.shared.config import get_default_config, get_config_from_file

import yaml
import ruamel.yaml
import json
import os


class ComplianceCoverageTestCase(unittest.TestCase):
    def setUp(self):
        service = "all"
        config = get_default_config(exclude_services=None)
        with_parameters = False
        if service == "all":
            self.services = Services(config=config)
            self.policy_names = self.services.get_display_names(with_parameters=with_parameters)
        else:
            self.services = Service(service_name=service, config=config)
            self.policy_names = self.services.get_display_names(with_parameters=with_parameters)
        self.compliance_coverage = ComplianceCoverage(display_names=self.policy_names)

    def test_markdown_table(self):
        markdown_table = self.compliance_coverage.markdown_table()
        summary = self.compliance_coverage.table_summary()
        print(markdown_table)

    # def test_csv_table(self):
    #     path = os.path.join(
    #         os.path.pardir,
    #         os.path.pardir,
    #         "tmp",
    #         "test.csv"
    #     )
    #     if os.path.exists(path):
    #         print("Removing the previous file")
    #         os.remove(path)
    #     self.compliance_coverage.csv_table(path, verbosity=0)
    #     print(f"CSV updated! Path: {path}")
