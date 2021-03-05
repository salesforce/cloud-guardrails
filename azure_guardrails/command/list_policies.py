"""

"""
import os
import logging
import json
import yaml
import click
from azure_guardrails import set_log_level
from azure_guardrails.logic.services import Services, Service
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
    type=click.Choice(["stdout", "yaml", "terraform"]),
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
    print("Getting policy names according to service\n")
    if fmt == "yaml":
        print_policies_in_yaml(service=service, with_parameters=with_parameters)


def print_policies_in_yaml(service: str, with_parameters: bool):
    if service == "all":
        services = Services()
        display_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
        result = yaml.dump(display_names)
        total_policies = 0
        for service_name in display_names.keys():
            total_policies += len(display_names[service_name])
    else:
        service = Service(service_name=service)
        display_names = service.get_display_names(with_parameters=with_parameters)
        result = yaml.dump(display_names)
        total_policies = len(display_names)

    print(result)
    print(f"total policies: {str(total_policies)}")
