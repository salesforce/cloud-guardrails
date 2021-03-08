import os
import json
import unittest
import csv
from click.testing import CliRunner
from azure_guardrails.shared.exclusions import get_default_exclusions
from azure_guardrails.shared.utils import get_compliance_table


class CsvSummaryTestCase(unittest.TestCase):
    def test_csv_summary(self):
        """CSV Summary test case"""
        service = "Key Vault"
        exclusions = get_default_exclusions()
        with_parameters = False
        # service = Service(service_name=service, exclusions=exclusions)
        # policy_names = service.get_display_names_sorted_by_service(with_parameters=with_parameters)

        results = get_compliance_table()
        print(json.dumps(results, indent=4))
