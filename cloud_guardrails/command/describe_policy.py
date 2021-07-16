# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""
Supply a Policy's display name or a policy ID and get some metadata about the policy.
"""
import logging
import json
import ruamel.yaml
import click
from cloud_guardrails import set_log_level
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies
from cloud_guardrails.shared.config import get_empty_config
logger = logging.getLogger(__name__)


@click.command(
    name="describe-policy",
    short_help="Get metadata about a Policy, given the policy name or ID."
)
# Policy Lookup Options
@optgroup.group("Policy Lookup Options", cls=RequiredMutuallyExclusiveOptionGroup, help="")
@optgroup.option("--name", "-n", "display_name", type=str, help="The display name of the policy")
@optgroup.option("--id", "-i", "policy_id", type=str, help="The short ID of the policy")
# Other Options
@optgroup.group("Other Options", help="")
@optgroup.option("--format", "-f", "fmt", type=click.Choice(["json", "yaml"]), required=False, default="yaml", help="Output format")
@click.option("--verbose", "-v", "verbosity", count=True)
def describe_policy(display_name: str, policy_id: str, fmt: str, verbosity: bool):
    set_log_level(verbosity)
    azure_policies = AzurePolicies(config=get_empty_config())
    # services = Services(config=get_empty_config())
    if policy_id:
        policy_definition = azure_policies.get_policy_definition(policy_id=policy_id)
    else:
        policy_definition = azure_policies.get_policy_definition_by_display_name(display_name=display_name)
    results_json = policy_definition.json()
    results_json.pop("id", None)
    if fmt == "yaml":
        results_str = ruamel.yaml.dump(results_json, Dumper=ruamel.yaml.RoundTripDumper)
        print()
        print(results_str)
    else:
        print(json.dumps(results_json, indent=4))
