import unittest
import os
import json
from azure_guardrails.shared.parameters_config import ParametersConfig, TerraformParameterV4
from azure_guardrails.terraform.terraform_v4 import TerraformTemplateWithParamsV4
from azure_guardrails.shared import utils
from azure_guardrails import set_stream_logger
from azure_guardrails.shared.config import get_default_config, get_config_from_file
import logging


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
        config = get_default_config(exclude_services=exclude_services)

        azure_policies = AzurePolicies(service_names=["Kubernetes"], config=config)
        policy_id_pairs = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=no_params, params_optional=params_optional, params_required=params_required,
            audit_only=audit_only)
        self.terraform_template_with_params = TerraformTemplateWithParamsV4(

        )g