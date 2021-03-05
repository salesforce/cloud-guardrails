"""

"""
import logging
import os
import click
from azure_guardrails import set_log_level
from azure_guardrails.shared import utils

logger = logging.getLogger(__name__)


@click.command(name="list-services", short_help="")
@click.option(
    "-v",
    "--verbose",
    "verbosity",
    count=True,
)
def list_services(verbosity):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)
    services = utils.get_service_names()
    for service in services:
        print(service)
