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

supported_services_argument_values = utils.get_service_names()
supported_services_argument_values.append("all")


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
    "--service",
    "-s",
    type=click.Choice(supported_services_argument_values),
    required=True,
    help="Services supported by Azure Policy definitions. Set to 'all' for all policies",
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
    "--target-name",
    "-n",
    "target_name",
    type=str,
    required=True,
    help="The target name. Must be the name of a subscription or management group.",
    envvar="TARGET_NAME"
)
@click.option(
    "--target-type",
    "-t",
    "target_type",
    required=True,
    type=click.Choice(["subscription", "mg"]),
    help="The target type - a subscription or management group.",
    envvar="TARGET_TYPE"
)
@click.option(
    "--set",
    "-s",
    "policy_set_name",
    type=str,
    required=True,
    help="The name to use for the resulting Azure Policy Set/Initiative.",
    envvar="POLICY_SET_NAME"
)
@click.option(
    "--enforce",
    "-e",
    "enforcement_mode",
    is_flag=True,
    default=False,
    help="Enforce Azure Policies instead of just auditing them.",
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
def generate_terraform(output_directory: str, service: str, with_parameters: bool, target_name: str, target_type: str,
                       policy_set_name: str, exclusions_file: str, enforcement_mode: bool, verbosity: int):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)
    if not exclusions_file:
        utils.print_red("You did not supply an exclusions file. Consider creating one to exclude different policies.")

    subscription_name = ""
    management_group = ""
    if target_type == "subscription":
        subscription_name = target_name
    else:
        management_group = target_name

    if service == "all":
        services = Services()
        display_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
        result = get_terraform_template(name=policy_set_name, policy_names=policy_names, subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
    else:
        service = Service(service_name=service)
        policy_names = service.get_display_names(with_parameters=False)

        result = get_terraform_template(name=policy_set_name, policy_names=policy_names, subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
    print(result)
