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
from azure_guardrails import set_log_level, set_stream_logger
from azure_guardrails.logic.terraform import get_terraform_template
from azure_guardrails.shared import utils, validate
from azure_guardrails.shared.compliance_data import ComplianceCoverage
from azure_guardrails.shared.config import get_default_config, get_config_from_file
from azure_guardrails.logic.services import Services, Service


logger = logging.getLogger(__name__)

supported_services_argument_values = utils.get_service_names()
supported_services_argument_values.append("all")


@click.command(name="generate-terraform", short_help="")
@click.option(
    "--service",
    "-s",
    type=click.Choice(supported_services_argument_values),
    required=True,
    help="Services supported by Azure Policy definitions. Set to 'all' for all policies",
    callback=validate.click_validate_supported_azure_service,
)
@click.option(
    "--target-name",
    "-n",
    "target_name",
    type=str,
    required=True,
    help="The target name. Must be the name of a subscription or management group.",
    envvar="TARGET_NAME",
    default="example"
)
@click.option(
    "--target-type",
    "-t",
    "target_type",
    required=True,
    type=click.Choice(["subscription", "mg"]),
    help="The target type - a subscription or management group.",
    envvar="TARGET_TYPE",
    default="subscription"
)
@click.option(
    "--policy-set-name",
    "-s",
    "policy_set_name",
    type=str,
    required=True,
    help="The name to use for the resulting Azure Policy Set/Initiative.",
    envvar="POLICY_SET_NAME",
    default="example"
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
    "--module-source",
    "-m",
    "terraform_module_source",
    type=str,
    required=True,
    help="The source to use for the Terraform remote module. You can set this to your own fork or private Git Repo if you don't want to rely on this source code.",
    envvar="TERRAFORM_MODULE_SOURCE",
    default=utils.DEFAULT_TERRAFORM_MODULE_SOURCE
)
@click.option(
    "--config-file",
    "-e",
    type=click.Path(exists=False),
    required=False,
    help="The config file",
)
@click.option(
    "--generate-summary",
    "-g",
    is_flag=True,
    default=False,
    help="Generate a Markdown table summary showing your policies and which standards they apply to.",
)
@click.option(
    "--with-parameters",
    "-p",
    is_flag=True,
    default=False,
    help="Include Policies with Parameters",
)
@click.option(
    "--quiet",
    "-q",
    is_flag=True,
    default=False,
)
def generate_terraform(service: str, with_parameters: bool, target_name: str, target_type: str,
                       policy_set_name: str, terraform_module_source: str, config_file: str, enforcement_mode: bool,
                       generate_summary: bool, quiet: bool):
    """
    Get Azure Policies
    """

    # For the Generate Terraform example, we will deviate from the -vvv behavior
    # and just force the user to use the quiet flag if they want to output via stdout
    if quiet:
        log_level = getattr(logging, "WARNING")
        set_stream_logger(level=log_level)
    else:
        log_level = getattr(logging, "INFO")
        set_stream_logger(level=log_level)

    if not config_file:
        logger.info("You did not supply an config file. Consider creating one to exclude different policies. We will use the default one.")
        config = get_default_config()
    else:
        config = get_config_from_file(config_file=config_file)

    subscription_name = ""
    management_group = ""
    if target_type == "subscription":
        subscription_name = target_name
    else:
        management_group = target_name

    # TODO: Move this back properly
    if with_parameters:
        services = Services(config=config)
        policy_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
        # Get the parameters for each of them

    else:
        if generate_summary:
            if service == "all":
                services = Services(config=config)
                policy_names = services.get_display_names(with_parameters=with_parameters)
            else:
                services = Service(service_name=service, config=config)
                policy_names = services.get_display_names(with_parameters=with_parameters)
            compliance_coverage = ComplianceCoverage(display_names=policy_names)
            markdown_table = compliance_coverage.markdown_table()
            print(markdown_table)
        else:
            if service == "all":
                services = Services(config=config)
                policy_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
                result = get_terraform_template(name=policy_set_name, policy_names=policy_names, subscription_name=subscription_name,
                                                management_group=management_group, enforcement_mode=enforcement_mode, module_source=terraform_module_source)
            else:
                services = Service(service_name=service, config=config)
                policy_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)

                result = get_terraform_template(name=policy_set_name, policy_names=policy_names, subscription_name=subscription_name,
                                                management_group=management_group, enforcement_mode=enforcement_mode, module_source=terraform_module_source)
            print(result)
