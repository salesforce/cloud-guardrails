import unittest
import json
from cloud_guardrails.shared.config import get_empty_config, get_default_config
from cloud_guardrails.templates.parameters_template import ParameterTemplate, ParameterSegment
from cloud_guardrails.shared import utils


class ParameterTemplateTestCase(unittest.TestCase):
    def setUp(self) -> None:
        self.config = get_default_config(
            match_only_keywords=["Metric alert rules should be configured on Batch accounts"]
        )
        self.config_enforce = get_default_config(
            match_only_keywords=["Storage account public access should be disallowed"]
        )
        self.parameter_template_audit = ParameterTemplate(config=self.config, params_optional=False, params_required=True, enforce=False)
        self.parameter_template_enforce = ParameterTemplate(config=self.config_enforce, params_optional=True, params_required=False, enforce=True)
        self.parameter_segment = ParameterSegment(parameter_name="effect", parameter_type="string", allowed_values=["AuditIfNotExists", "Disabled"], default_value="AuditIfNotExists", value="AuditIfNotExists")

    def test_parameter_segment(self):
        print(self.parameter_segment)

    def test_set_parameter_config_case_1_audit(self):
        results = self.parameter_template_audit.json()
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

    def test_set_parameter_config_case_2_enforce(self):
        results = self.parameter_template_enforce.json()
        print(json.dumps(results, indent=4))
        expected_results = {
            "Storage": {
                "Storage account public access should be disallowed": [
                    {
                        "name": "effect",
                        "type": "string",
                        "allowed_values": [
                            "audit",
                            "deny",
                            "disabled"
                        ],
                        "default_value": "audit",
                        "value": "deny"
                    }
                ]
            }
        }
        default_value = results["Storage"]["Storage account public access should be disallowed"][0]["default_value"]
        value = results["Storage"]["Storage account public access should be disallowed"][0]["value"]

        self.assertEqual(default_value, "audit")
        self.assertEqual(value, "deny")
        # self.assertDictEqual(results, expected_results)

    def test_parameters_template_rendered_case_1_audit(self):
        results = self.parameter_template_audit.rendered()
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

    def test_parameters_template_rendered_case_2_enforce(self):
        results = self.parameter_template_enforce.rendered()
        print(results)
        expected_results = """# ---------------------------------------------------------------------------------------------------------------------
# Storage
# ---------------------------------------------------------------------------------------------------------------------
Storage:
  "Storage account public access should be disallowed":
    effect: deny  # Allowed: ["audit", "deny", "disabled"]
"""
        self.assertEqual(results, expected_results)
