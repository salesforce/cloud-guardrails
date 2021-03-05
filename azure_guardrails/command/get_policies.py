"""
List exposable resources
"""
import logging
import click
from azure_guardrails import set_log_level
from azure_guardrails.shared import constants

logger = logging.getLogger(__name__)


@click.command(name="get-policies", short_help="")
@click.option(
    "--service",
    "-s",
    type=str,
    required=True,
    help=f"The Azure Policy ",
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
