import unittest
import os
import json
from azure_guardrails.shared.parameters_config import ParametersConfig, TerraformParameterV4
from azure_guardrails.guardrails.policy_definition import PolicyDefinition
from azure_guardrails.shared import utils
from azure_guardrails import set_stream_logger
import logging
from jinja2 import Template, Environment, FileSystemLoader


class ParametersConfigTestCase(unittest.TestCase):
    def setUp(self) -> None:
        example_config_file = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            os.path.pardir,
            os.path.pardir,
            "examples",
            "parameters-config-example.yml"
        ))
        # Let's view the logs
        set_stream_logger("azure_guardrails.shared.parameters_config", level=logging.DEBUG)

        self.parameters_config = ParametersConfig(
            parameter_config_file=example_config_file,
            params_optional=True,
            params_required=True
        )

    def test_config_format(self):
        # results = self.parameters_config.parameters
        results = self.parameters_config.config
        print(json.dumps(results, indent=4))
        expected_results = {
            "API Management": {
                "API Management service should use a SKU that supports virtual networks": {
                    "effect": "Deny",
                    "listOfAllowedSKUs": [
                        "Developer",
                        "Premium",
                        "Isolated"
                    ],
                    "policy_id": "73ef9241-5d81-4cd4-b483-8443d1730fe5"
                }
            },
            "Kubernetes": {
                "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {},
                    "cpuLimit": "200m",
                    "memoryLimit": "1Gi",
                    "policy_id": "e345eecc-fa47-480f-9e88-67dcc122b164"
                },
                "Kubernetes cluster containers should not share host process ID or host IPC namespace": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {},
                    "policy_id": "47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8"
                },
                "Kubernetes cluster containers should not use forbidden sysctl interfaces": {
                    "effect": "Audit",
                    "excludedNamespaces": [
                        "kube-system",
                        "gatekeeper-system",
                        "azure-arc"
                    ],
                    "namespaces": [],
                    "labelSelector": {},
                    "forbiddenSysctls": [],
                    "policy_id": "56d0a13f-712f-466b-8416-56fb354fb823"
                }
            }
        }
        self.assertDictEqual(results, expected_results)

    def test_get_parameter_value_from_config_case_1_user_supplied(self):
        policy_id = "73ef9241-5d81-4cd4-b483-8443d1730fe5"
        display_name = "API Management service should use a SKU that supports virtual networks"
        parameter_name = "effect"
        result = self.parameters_config.get_parameter_value_from_config(display_name=display_name,
                                                                        parameter_name=parameter_name)
        print(result)
        # default_value is "Audit", but our user-supplied config set the value to "Deny". It should return the user-supplied value.
        self.assertEqual(result, "Deny")

    def test_get_parameter_value_from_config_case_2_empty_user_supplied_value(self):
        policy_id = "47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8"
        display_name = "Kubernetes cluster containers should not share host process ID or host IPC namespace"
        parameter_name = "namespaces"
        results = self.parameters_config.get_parameter_value_from_config(display_name=display_name,
                                                                         parameter_name=parameter_name)
        print(json.dumps(results, indent=4))
        self.assertTrue(isinstance(results, list))
        self.assertListEqual(results, [])

    # TODO: test_get_parameter_value_from_config_case_3_user_needs_to_supply_required_value
    # TODO: Do this one next!!! It will fix your problem with required values
    def test_get_parameter_value_from_config_case_3_user_needs_to_supply_required_value(self):
        print()
        display_name = "Only approved VM extensions should be installed"
        parameter_name = "approvedExtensions"
        results = self.parameters_config.get_parameter_value_from_config(display_name=display_name,
                                                                         parameter_name=parameter_name)
        print(json.dumps(results, indent=4))
        # It should be none, because the user didn't provide anything
        self.assertIsNone(results)

    def test_parameter_config_parameters(self):
        print(json.dumps(self.parameters_config.parameters(), indent=4))
        # print(self.parameters_config.parameters)

    def test_format_parameter_config_segment(self):
        class ParameterSegment:
            def __init__(self, parameter_name: str, parameter_type: str, value=None, default_value=None,
                         allowed_values: list = None):
                self.name = parameter_name
                self.type = parameter_type
                self.allowed_values = allowed_values
                self.default_value = default_value
                self.value = value

        allowed_values_metric_name = None
        metric_name = ParameterSegment(parameter_name="metricName", parameter_type="String", default_value=None,
                                       value=None, allowed_values=allowed_values_metric_name)
        allowed_values_effect = ["AuditIfNotExists", "Disabled"]
        effect = ParameterSegment(parameter_name="effect", parameter_type="String", default_value="Audit",
                                  value="Audit", allowed_values=allowed_values_effect)

        deny_list_of_stuff = ["Value1", "Value2"]
        list_of_stuff = ParameterSegment(parameter_name="denyListOfStuff", parameter_type="String",
                                         default_value="Audit",
                                         value=deny_list_of_stuff, allowed_values=deny_list_of_stuff)
        empty_list_param = ParameterSegment(parameter_name="emptyListParam", parameter_type="String",
                                            default_value=None,
                                            value=[], allowed_values=["something", "something", "dark", "side"])

        categorized_parameters = {
            "Batch": {
                "Metric alert rules should be configured on Batch accounts": [
                    metric_name,
                    effect,
                    list_of_stuff,
                    empty_list_param
                ]
            }
        }

        template_contents = dict(
            # parameter_segments=parameter_segments,
            categorized_parameters=categorized_parameters
        )
        template_path = os.path.join(os.path.dirname(__file__))
        env = Environment(loader=FileSystemLoader(template_path), lstrip_blocks=True)  # nosec
        env.tests['is_none_instance'] = utils.is_none_instance

        def is_list(value):
            return isinstance(value, list)

        env.tests['is_a_list'] = is_list

        template = env.get_template("parameter-yaml-segment.yml.j2")
        result = template.render(t=template_contents)
        print(result)
        expected_result = """# ---------------------------------------------------------------------------------------------------------------------
# Batch
# ---------------------------------------------------------------------------------------------------------------------
Batch:
  Metric alert rules should be configured on Batch accounts:
    metricName: # Note: No default parameters
    effect: Audit  # Allowed: ["AuditIfNotExists", "Disabled"]
    denyListOfStuff:
        - Value1
        - Value2 # Allowed: ["Value1", "Value2"]
    emptyListParam: [] # Note: No default parameters # Allowed: ["something", "something", "dark", "side"]
"""
        self.assertEqual(result, expected_result)
        # print()


class TerraformParameterV4TestCase(unittest.TestCase):
    def setUp(self) -> None:
        name = "namespaces"
        policy_definition_name = "Kubernetes cluster containers should not share host process ID or host IPC namespace"
        initiative_parameters_json = {
            "type": "Array",
            "metadata": {
                "displayName": "Namespace inclusions",
                "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
            },
            "defaultValue": []
        }
        value = ["example"]
        parameter_type = "Array"
        default_value = []
        self.terraform_parameter = TerraformParameterV4(
            name="effect",
            service="Kubernetes",
            policy_definition_name=policy_definition_name,
            initiative_parameters_json=initiative_parameters_json,
            parameter_type=parameter_type,
            default_value=default_value,
            value=value
        )

    def test_terraform_v4_parameter(self):
        print(json.dumps(self.terraform_parameter.json(), indent=4))
        results = self.terraform_parameter.__dict__
        print(json.dumps(self.terraform_parameter.__dict__, indent=4))
        expected_results = {
            "name": "effect",
            "service": "Kubernetes",
            "policy_definition_name": "Kubernetes cluster containers should not share host process ID or host IPC namespace",
            "initiative_parameters_json": {
                "type": "Array",
                "metadata": {
                    "displayName": "Namespace inclusions",
                    "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
                },
                "defaultValue": []
            },
            "parameter_type": "Array",
            "default_value": [],
            "value": ["example"]
        }
        self.assertDictEqual(results, expected_results)
