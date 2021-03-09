import os
import json
import unittest
import csv
from click.testing import CliRunner
from azure_guardrails.shared.config import get_default_config
from azure_guardrails.shared.utils import get_compliance_table


class CsvSummaryTestCase(unittest.TestCase):
    def test_csv_summary(self):
        """CSV Summary test case"""
        service = "Key Vault"
        config = get_default_config()
        with_parameters = False
        # service = Service(service_name=service, config=config)
        # policy_names = service.get_display_names_sorted_by_service(with_parameters=with_parameters)

        results = get_compliance_table()
        # print(json.dumps(results, indent=4))
