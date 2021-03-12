"""

"""
import os
import logging
import json
import yaml
import click
from azure_guardrails import set_log_level
from azure_guardrails.guardrails.services import Services, Service
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
@click.option(
    "--with-parameters",
    "-p",
    is_flag=True,
    default=False,
    help="Include Policies with Parameters",
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
def list_policies(service: str, with_parameters: bool, fmt: str, verbosity: int):
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
        print_policies_in_yaml(service=service, with_parameters=with_parameters, verbosity=verbosity)
    else:
        print_policies_in_stdout(service=service, with_parameters=with_parameters, verbosity=verbosity)


def get_display_names_sorted_by_service(service: str, with_parameters: bool) -> dict:
    if service == "all":
        services = Services()
        display_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
    else:
        services = Services(service_names=[service])
        display_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
    return display_names


def print_policies_in_yaml(service: str, with_parameters: bool, verbosity: int):
    display_names = get_display_names_sorted_by_service(service=service, with_parameters=with_parameters)
    result = yaml.dump(display_names)
    total_policies = 0
    for service_name in display_names.keys():
        total_policies += len(display_names[service_name])
    print(result)
    if verbosity >= 1:
        print(f"total policies: {str(total_policies)}")


def print_policies_in_stdout(service: str, with_parameters: bool, verbosity: int):
    # TODO: Figure out if I should just print all of the policies as a list or if they should be indented. If indented, uncomment the commented lines below.
    display_names = get_display_names_sorted_by_service(service=service, with_parameters=with_parameters)
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
