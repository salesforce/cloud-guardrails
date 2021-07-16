import json
import unittest
import os
import hcl2
from cloud_guardrails.shared import utils
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies


class HclParserTestCase(unittest.TestCase):
    def setUp(self) -> None:
        no_params_file = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            os.path.pardir,
            "files",
            "no_params.tf"
        ))
        with open(no_params_file, 'r') as file:
            self.no_params = hcl2.load(file)

        params_optional_file = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            os.path.pardir,
            "files",
            "params_optional.tf"
        ))
        with open(params_optional_file, 'r') as file:
            self.params_optional = hcl2.load(file)

        params_required_file = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            os.path.pardir,
            "files",
            "params_required.tf"
        ))
        with open(params_required_file, 'r') as file:
            self.params_required = hcl2.load(file)

        self.azure_policies = AzurePolicies()

    def test_hcl_no_params(self):
        policy_ids = self.no_params.get("locals")[0].get("policy_ids_no_params")[0]
        # There should be no parameters for any of the policy definitions with these IDs
        for policy_id in policy_ids:
            parameters = self.azure_policies.get_parameters_by_policy_id(policy_id=policy_id, include_effect=False)
            # print(parameters)
            self.assertDictEqual(parameters, {})

    def test_hcl_params_optional(self):
        policy_ids = self.params_optional['locals'][0]['policy_ids_example_PO_Audit'][0]
        for policy_id in policy_ids:
            optional_parameters = self.azure_policies.get_optional_parameters(policy_id=policy_id)
            # print(optional_parameters)
            # The list of optional parameters should not be empty
            self.assertTrue(optional_parameters)
            # there should be no required parameters, so the list should be empty
            required_parameters = self.azure_policies.get_required_parameters(policy_id=policy_id)
            self.assertListEqual(required_parameters, [])

    def test_hcl_params_required(self):
        policy_ids = self.params_required['locals'][0]['policy_ids_example_PR_Audit'][0]
        for policy_id in policy_ids:
            required_parameters = self.azure_policies.get_required_parameters(policy_id=policy_id)
            # The list of required parameters should not be empty
            self.assertTrue(required_parameters)

            # the list of optional parameters should be empty
            optional_parameters = self.azure_policies.get_optional_parameters(policy_id=policy_id)
            self.assertListEqual(optional_parameters, [])
            # print(optional_parameters)

