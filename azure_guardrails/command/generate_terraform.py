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
from azure_guardrails.terraform.terraform import get_terraform_template, TerraformTemplate
from azure_guardrails.shared import utils, validate
from azure_guardrails.scrapers.compliance_data import ComplianceCoverage
from azure_guardrails.shared.config import get_default_config, get_config_from_file
from azure_guardrails.guardrails.services import Services, Service

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
    "--exclude-services",
    "exclude_services",
    type=str,
    help="Exclude specific services (comma-separated) without using a config file.",
    callback=validate.click_validate_comma_separated_excluded_services
)
# TODO: Mutually exclusive option groups
# https://github.com/click-contrib/click-option-group
# https://stackoverflow.com/questions/37310718/mutually-exclusive-option-groups-in-python-click
@click.option(
    "--subscription",
    type=str,
    help="The name of a subscription. Supply either this or --management-group",
)
@click.option(
    "--management-group",
    type=str,
    help="The name of a management group. Supply either this or --subscription",
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
    "--module",
    "-m",
    "module_source",
    type=str,
    required=True,
    help="The source to use for the Terraform remote module. You can set this to your own fork or private Git Repo if you don't want to rely on this source code.",
    envvar="MODULE_SOURCE",
    default=utils.DEFAULT_TERRAFORM_MODULE_SOURCE
)
@click.option(
    "--parameter-options",
    "-o",
    type=click.Choice(["defaults", "empty"], case_sensitive=True),
    multiple=True,
    required=False,
    default=None,
    help="Include Policies with Parameters that have default values (defaults) and/or Policies that have empty defaults that you must fill in (empty).",
    # callback=validate.click_validate_supported_azure_service,  # TODO: Write this validation
)
@click.option(
    "--config",
    "-c",
    "config_file",
    type=click.Path(exists=False),
    required=False,
    help="The config file",
)
@click.option(
    "--no-summary",
    "-n",
    is_flag=True,
    default=False,
    help="Do not generate markdown or CSV summary files associated with the Terraform output",
)
@click.option(
    "-v",
    "--verbose",
    "verbosity",
    count=True,
)
def generate_terraform(
        service: str,
        exclude_services: list,
        subscription: str,
        management_group: str,
        enforcement_mode: bool,
        module_source: str,
        parameter_options: list,
        config_file: str,
        no_summary: bool,
        verbosity: int
):
    """
    Get Azure Policies
    """
    set_log_level(verbosity)

    # TODO: Remove initiative
    initiative = "example"

    if not config_file:
        logger.info(
            "You did not supply an config file. Consider creating one to exclude different policies. We will use the default one.")
        config = get_default_config(exclude_services=exclude_services)
    else:
        config = get_config_from_file(config_file=config_file, exclude_services=exclude_services)

    if subscription:
        management_group = ""
    else:
        subscription = ""

    # if generate_summary:
    #     if service == "all":
    #         services = Services(config=config)
    #         policy_names = services.get_display_names(with_parameters=with_parameters)
    #     else:
    #         services = Service(service_name=service, config=config)
    #         policy_names = services.get_display_names(with_parameters=with_parameters)
    #     compliance_coverage = ComplianceCoverage(display_names=policy_names)
    #     markdown_table = compliance_coverage.markdown_table()
    #     print(markdown_table)
    # else:
    with_parameters = False
    include_empty_defaults = False
    parameter_options = list(parameter_options)
    if parameter_options:
        if "defaults" in parameter_options:
            with_parameters = True
        if "empty" in parameter_options:
            include_empty_defaults = True

    if service == "all":
        services = Services(config=config)
    else:
        services = Services(service_names=[service], config=config)
    if with_parameters:
        display_names = services.get_display_names_by_service_with_parameters(include_empty_defaults=include_empty_defaults)
        terraform_template = TerraformTemplate(name=initiative, parameters=display_names,
                                               subscription_name=subscription,
                                               management_group=management_group,
                                               enforcement_mode=enforcement_mode,
                                               module_source=module_source)
        result = terraform_template.rendered()
    else:
        display_names = services.get_display_names_sorted_by_service(with_parameters=with_parameters)
        result = get_terraform_template(name=initiative, policy_names=display_names,
                                        subscription_name=subscription,
                                        management_group=management_group, enforcement_mode=enforcement_mode,
                                        module_source=module_source)
    print(result)
