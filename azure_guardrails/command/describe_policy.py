"""
Supply a Policy's display name or a policy ID and get some metadata about the policy.
"""
import logging
import yaml
import ruamel.yaml
import click
from azure_guardrails import set_log_level
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from azure_guardrails.shared import utils, validate
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.guardrails.services import Services
from azure_guardrails.shared.config import get_empty_config
logger = logging.getLogger(__name__)


@click.command(name="describe-policy", short_help="Supply a Policy's display name or a policy ID and get some metadata about the policy.")
@optgroup.group(
    "Policy Lookup Options",
    cls=RequiredMutuallyExclusiveOptionGroup,
    help="",
)
@optgroup.option(
    "--name",
    "-n",
    "display_name",
    type=str,
    help="The display name of the policy",
)
@optgroup.option(
    "--id",
    "-i",
    "policy_id",
    type=str,
    help="The short ID of the policy",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def describe_policy(display_name: str, policy_id: str, verbosity: bool):
    set_log_level(verbosity)
    azure_policies = AzurePolicies(config=get_empty_config())
    # services = Services(config=get_empty_config())
    if policy_id:
        policy_definition = azure_policies.get_policy_definition(policy_id=policy_id)
    else:
        policy_definition = azure_policies.get_policy_definition_by_display_name(display_name=display_name)
    results_json = policy_definition.json()
    results_json.pop("id", None)
    results_str = ruamel.yaml.dump(results_json, Dumper=ruamel.yaml.RoundTripDumper)
    print()
    print(results_str)
