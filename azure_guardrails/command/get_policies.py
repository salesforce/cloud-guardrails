"""

"""
import os
import logging
import json
import click
from azure_guardrails import set_log_level
from azure_guardrails.shared import constants, utils

logger = logging.getLogger(__name__)


@click.command(name="get-policies", short_help="")
@click.option(
    "--service",
    "-s",
    type=str,
    required=True,
    help=f"The Azure PolicyDefinition ",
    # TODO: Add callback validator
)
@click.option(
    "--with-parameters",
    "-p",
    is_flag=True,
    default=False,
    help="Include Policies with Parameters",
)
@click.option(
    "-v",
    "--verbose",
    "verbosity",
    count=True,
)
def get_policies(service, verbosity):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)
    service_names = utils.get_service_names()
    if service not in service_names:
        raise Exception(f"Please provide a valid service name. Valid service names are {service_names}")
    print("Getting policy names according to service")
