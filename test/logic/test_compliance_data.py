import os
import unittest
import json
from azure_guardrails.shared import utils
from azure_guardrails.scrapers.compliance_data import ComplianceResults

#
# class ComplianceDataTestCase(unittest.TestCase):
#     def setUp(self):
#         raw_json_results_path = os.path.abspath(os.path.join(
#             os.path.dirname(__file__),
#             os.path.pardir,
#             os.path.pardir,
#             "azure_guardrails",
#             "shared",
#             "data",
#             "raw_results.json"
#         ))
#         with open(raw_json_results_path) as json_file:
#             compliance_data_json = json.load(json_file)
#         self.compliance_results = ComplianceResults(compliance_data_json)
#
#     def test_stuff(self):
#         print(json.dumps(self.compliance_results.json(), indent=4))
