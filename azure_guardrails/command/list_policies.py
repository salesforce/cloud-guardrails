"""

"""
import os
import logging
import json
import yaml
import click
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from azure_guardrails import set_log_level
from azure_guardrails.guardrails.services import Services
from azure_guardrails.shared import utils, validate

logger = logging.getLogger(__name__)


@click.command(name="list-policies", short_help="")
@click.option(
    "--service",
    "-s",
    type=str,
    required=True,
    help="Services supported by Azure Policy definitions",
    callback=validate.click_validate_supported_azure_service,
)
@optgroup.group(
    "Parameter Options",
    cls=RequiredMutuallyExclusiveOptionGroup,
    help="",
)
@optgroup.option(
    "--all-policies",
    is_flag=True,
    default=False,
    help="Show all policies, regardless of whether or not they have parameters",
)
@optgroup.option(
    "--no-params",
    is_flag=True,
    default=False,
    help="Only generate policies that do NOT require parameters",
)
@optgroup.option(
    "--params-optional",
    is_flag=True,
    default=False,
    help="Only generate policies where parameters are OPTIONAL",
)
@optgroup.option(
    "--params-required",
    is_flag=True,
    default=False,
    help="Only generate policies where parameters are REQUIRED",
)
@click.option(
    "--format",
    "-f",
    "fmt",
    type=click.Choice(["stdout", "yaml"]),
    required=False,
    default="stdout",
    help="Output format",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def list_policies(service: str, all_policies: bool, no_params: bool, params_optional: bool, params_required: bool, fmt: str, verbosity: int):
    """
    List Azure Policies
    """

    set_log_level(verbosity)
    service_names = utils.get_service_names()
    service_names.append("all")
    if service not in service_names:
        raise Exception(f"Please provide a valid service name. Valid service names are {service_names}")
    if verbosity >= 1:
        utils.print_grey("Getting policy names according to service\n")
    if fmt == "yaml":
        print_policies_in_yaml(service=service, all_policies=all_policies, no_params=no_params, params_optional=params_optional, params_required=params_required, verbosity=verbosity)
    else:
        print_policies_in_stdout(service=service, all_policies=all_policies, no_params=no_params, params_optional=params_optional, params_required=params_required, verbosity=verbosity)


def get_display_names_sorted_by_service(service: str, all_policies: bool, no_params: bool, params_optional: bool, params_required: bool) -> dict:
    if service == "all":
        services = Services()
    else:
        services = Services(service_names=[service])
    display_names = []
    if all_policies:
        display_names = services.get_all_display_names_sorted_by_service()
    elif no_params:
        display_names = services.get_display_names_sorted_by_service_no_params()
    elif params_optional:
        display_names = services.get_display_names_sorted_by_service_with_params(params_required=False)
    elif params_required:
        display_names = services.get_display_names_sorted_by_service_with_params(params_required=True)
    return display_names


def print_policies_in_yaml(service: str, all_policies: bool, no_params: bool, params_optional: bool, params_required: bool, verbosity: int):
    display_names = get_display_names_sorted_by_service(service=service, all_policies=all_policies, no_params=no_params, params_optional=params_optional, params_required=params_required)
    result = yaml.dump(display_names)
    total_policies = 0
    for service_name in display_names.keys():
        total_policies += len(display_names[service_name])
    print(result)
    if verbosity >= 1:
        print(f"total policies: {str(total_policies)}")


def print_policies_in_stdout(service: str, all_policies: bool, no_params: bool, params_optional: bool, params_required: bool, verbosity: int):
    # TODO: Figure out if I should just print all of the policies as a list or if they should be indented. If indented, uncomment the commented lines below.
    display_names = get_display_names_sorted_by_service(service=service, all_policies=all_policies, no_params=no_params, params_optional=params_optional, params_required=params_required)
    total_policies = 0
    for service_name in display_names.keys():
        # print(f"{service_name}:")
        total_policies += len(display_names[service_name])
        for policy_name in display_names.get(service_name):
            print(policy_name)
            # print(f"\t{policy_name}")
        # print("\n")

    if verbosity >= 1:
        print(f"total policies: {str(total_policies)}")
