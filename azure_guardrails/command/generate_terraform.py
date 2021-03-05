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
from azure_guardrails.logic.terraform import get_terraform_template
from azure_guardrails.shared import utils, validate
from azure_guardrails.logic.services import Services, Service


logger = logging.getLogger(__name__)


@click.command(name="generate-terraform", short_help="")
@click.option(
    "--directory",
    "-d",
    "output_directory",
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
def generate_terraform(output_directory: str, exclusions_file: str, verbosity: int):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)
    if not exclusions_file:
        utils.print_red("You did not supply an exclusions file. Consider creating one to exclude different policies.")

    # TODO: Parameterize this service
    service = Service(service_name="Key Vault")
    policy_names = service.get_display_names(with_parameters=False)
    name = "test"
    subscription_name = "example-subscription"
    management_group = ""
    enforcement_mode = False
    result = get_terraform_template(name=name, policy_names=policy_names, subscription_name=subscription_name, management_group=management_group, enforcement_mode=enforcement_mode)
    print(result)
