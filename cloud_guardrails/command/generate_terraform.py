# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""
Generate Terraform for the Azure Policies
"""
import os
import logging
import click
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from cloud_guardrails import set_log_level
from cloud_guardrails.shared import utils, validate
from cloud_guardrails.shared.config import get_default_config, get_config_from_file
from cloud_guardrails.terraform.guardrails import TerraformGuardrails

logger = logging.getLogger(__name__)

supported_services_argument_values = utils.get_service_names()
supported_services_argument_values.append("all")


@click.command(
    name="generate-terraform",
    short_help="Generate Terraform to deploy built-in Azure Policies rapidly."
)
# Policy selection - options to select different policies based on services or to apply enforcement mode
@optgroup.group("Azure Policy selection", help="")
@optgroup.option("--service", "-s", type=str, default="all", help="Services supported by Azure Policy definitions. Defaults to 'all' for all services.", callback=validate.click_validate_supported_azure_service)
@optgroup.option("--exclude-services", "exclude_services", type=str, help="Exclude specific services (comma-separated) without using a config file.", callback=validate.click_validate_comma_separated_excluded_services)
@optgroup.option("--enforce", "-e", "enforcement_mode", is_flag=True, default=False, help="Enforce the security guardrails using 'Deny' mode instead of 'Audit' mode.")
# Config file and Parameters file options
@optgroup.group("Configuration", help="")
@optgroup.option("--config", "-c", "config_file", type=click.Path(exists=False), required=False, help="The config file, generated by the create-config-file command.")
@optgroup.option("--parameters", "-p", "parameters_config_file", type=click.Path(exists=False), required=False, default=None, help="The parameters file, generated by the create-parameters-file command.")
# Options for Output files - the Terraform output, CSV summary output, and Markdown output
@optgroup.group("Output file options", help="")
@optgroup.option("--output", "-o", "output_directory", type=click.Path(exists=False, file_okay=False, dir_okay=True), default=os.getcwd(), help="Specify the *directory* to save the Terraform output. Defaults to current directory.")
@optgroup.option("--no-summary", "-n", is_flag=True, help="Do not generate markdown or CSV summary files associated with the Terraform output")
# Parameter options - Select policies with no parameters, optional parameters, or required parameters.
@optgroup.group("Parameter Options", cls=RequiredMutuallyExclusiveOptionGroup, help="")
@optgroup.option("--no-params", is_flag=True, default=False, help="Only generate policies that do NOT require parameters")
@optgroup.option("--params-optional", is_flag=True, default=False, help="Only generate policies where parameters are OPTIONAL",)
@optgroup.option("--params-required", is_flag=True, default=False, help="Only generate policies where parameters are REQUIRED",)
# Scope - apply to a management group OR a subscription
@optgroup.group("Policy Scope Targets", cls=RequiredMutuallyExclusiveOptionGroup, help="")
@optgroup.option("--subscription", type=str, help="The name of a subscription. Supply either this or --management-group")
@optgroup.option("--management-group", type=str, help="The name of a management group. Supply either this or --subscription")
@click.option("-v", "--verbose", "verbosity", count=True)
def generate_terraform(
    service: str,
    exclude_services: list,
    config_file: str,
    parameters_config_file: str,
    no_summary: bool,
    output_directory: str,
    no_params: bool,
    params_optional: bool,
    params_required: bool,
    subscription: str,
    management_group: str,
    enforcement_mode: bool,
    verbosity: int,
):
    set_log_level(verbosity)

    # Get the config file
    if not config_file:
        logger.info(
            "You did not supply an config file. Consider creating one to exclude different policies. We will use the default one."
        )
        config = get_default_config(exclude_services=exclude_services)
    else:
        config = get_config_from_file(
            config_file=config_file, exclude_services=exclude_services
        )

    # Policy Initiative Category
    category = "Testing"

    # Read the config file
    if parameters_config_file:
        parameters_config = utils.read_yaml_file(parameters_config_file)
    else:
        parameters_config = None

    terraform = TerraformGuardrails(
        service=service,
        config=config,
        subscription=subscription,
        management_group=management_group,
        parameters_config=parameters_config,
        no_params=no_params,
        params_optional=params_optional,
        params_required=params_required,
        category=category,
        enforcement_mode=enforcement_mode,
        verbosity=verbosity
    )
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    output_file = os.path.join(output_directory, terraform.file_name)
    result = terraform.create_terraform_file(output_file=output_file)
    if not result:
        raise Exception("The configuration you've provided does not match any Azure Policies. Consider opening up your configuration and try again.")
    provider_file = os.path.join(output_directory, "provider.tf")
    terraform.create_terraform_provider_file(output_file=provider_file)

    # Print success message
    terraform.print_success_message(output_file=output_file, output_directory=output_directory, enforcement_mode=enforcement_mode)

    # Markdown and CSV Summary files
    if not no_summary:
        terraform.create_markdown_summary_file(directory=output_directory)
        terraform.create_csv_summary_file(directory=output_directory)
