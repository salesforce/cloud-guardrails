"""
Generate Terraform for the Azure Policies
"""
import os
import logging
import json
from pathlib import Path
import yaml
import click
from colorama import Fore, Back
from azure_guardrails import set_log_level
from azure_guardrails.shared import utils, validate

logger = logging.getLogger(__name__)


@click.command(name="generate-terraform", short_help="")
@click.option(
    "--directory",
    "-d",
    "terraform_directory",
    type=click.Path(exists=False),
    required=True,
    help="The path to the directory where you will create your Terraform code.",
)
@click.option(
    "--exclusions-file",
    "-e",
    type=click.Path(exists=False),
    required=False,
    help="The exclusions file",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def generate_terraform(terraform_directory: str, exclusions_file: str, verbosity: int):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)
    if not exclusions_file:
        utils.print_red("You did not supply an exclusions file. Consider creating one to exclude different policies.")

