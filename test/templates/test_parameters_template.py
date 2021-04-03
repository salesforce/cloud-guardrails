import unittest
import json
from azure_guardrails.shared.config import get_empty_config, get_default_config
from azure_guardrails.templates.parameters_template import ParameterTemplate
from azure_guardrails.shared import utils


class ParameterTemplateTestCase(unittest.TestCase):
    def setUp(self) -> None:
        self.config = get_default_config(
            match_only_keywords=["Metric alert rules should be configured on Batch accounts"]
        )
        self.parameter_template = ParameterTemplate(config=self.config, params_optional=False, params_required=True)

    def test_set_parameter_config(self):
        results = self.parameter_template.json()
        print(json.dumps(results, indent=4))
        expected_results = {
            "Batch": {
                "Metric alert rules should be configured on Batch accounts": [
                    {
                        "name": "effect",
                        "type": "string",
                        "allowed_values": [
                            "AuditIfNotExists",
                            "Disabled"
                        ],
                        "default_value": "AuditIfNotExists",
                        "value": "AuditIfNotExists"
                    },
                    {
                        "name": "metricName",
                        "type": "String",
                        "allowed_values": None,
                        "default_value": None,
                        "value": None
                    }
                ]
            }
        }
        self.assertDictEqual(results, expected_results)

    def test_parameters_template_rendered(self):
        results = self.parameter_template.rendered()
        print(results)
        expected_results = """# ---------------------------------------------------------------------------------------------------------------------
# Batch
# ---------------------------------------------------------------------------------------------------------------------
Batch:
  "Metric alert rules should be configured on Batch accounts":
    effect: AuditIfNotExists  # Allowed: ["AuditIfNotExists", "Disabled"]
    metricName: # Note: No default parameters
"""
        self.assertEqual(results, expected_results)
