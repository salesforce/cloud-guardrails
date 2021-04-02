"""
Generate Terraform for the Azure Policies
"""
import os
import logging
import click
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from azure_guardrails import set_log_level
from azure_guardrails.terraform.terraform import TerraformTemplateNoParams
from azure_guardrails.terraform.terraform_v5 import TerraformTemplateWithParamsV5
from azure_guardrails.shared.iam_definition import AzurePolicies
from azure_guardrails.shared import utils, validate
from azure_guardrails.shared.config import get_default_config, get_config_from_file
from azure_guardrails.shared.parameters_config import ParametersConfig, TerraformParameterV4
from azure_guardrails.shared.parameters_categorized import OverallCategorizedParameters

logger = logging.getLogger(__name__)

supported_services_argument_values = utils.get_service_names()
supported_services_argument_values.append("all")


@click.command(name="generate-terraform", short_help="")
@optgroup.group("Azure Policy selection", help="")
@optgroup.option(
    "--service",
    "-s",
    type=str,
    # type=click.Choice(supported_services_argument_values),
    required=True,
    default="all",
    help="Services supported by Azure Policy definitions. Set to 'all' for all policies",
    callback=validate.click_validate_supported_azure_service,
)
@optgroup.option(
    "--exclude-services",
    "exclude_services",
    type=str,
    help="Exclude specific services (comma-separated) without using a config file.",
    callback=validate.click_validate_comma_separated_excluded_services,
)
@optgroup.option(
    "--enforce",
    "-e",
    "enforcement_mode",
    is_flag=True,
    default=False,
    help="Deny bad actions instead of auditing them.",
)
@optgroup.group("Configuration", help="")
@optgroup.option(
    "--config-file",
    "-c",
    "config_file",
    type=click.Path(exists=False),
    required=False,
    help="The config file",
)
@optgroup.option(
    "--parameters-file",
    "-p",
    "parameters_config_file",
    type=click.Path(exists=False),
    required=False,
    default=None,
    help="The parameters config file",
)
@optgroup.group(
    "Parameter Options",
    cls=RequiredMutuallyExclusiveOptionGroup,
    help="",
)
@optgroup.option(
    "--no-params",
    is_flag=True,
    default=False,
    help="Only generate policies that do NOT require parameters",
)
@optgroup.option(
    "--params-optional",
    is_flag=True,
    default=False,
    help="Only generate policies where parameters are OPTIONAL",
)
@optgroup.option(
    "--params-required",
    is_flag=True,
    default=False,
    help="Only generate policies where parameters are REQUIRED",
)
# Mutually exclusive option groups
# https://github.com/click-contrib/click-option-group
# https://stackoverflow.com/questions/37310718/mutually-exclusive-option-groups-in-python-click
@optgroup.group(
    "Policy Scope Targets",
    cls=RequiredMutuallyExclusiveOptionGroup,
    help="",
)
@optgroup.option(
    "--subscription",
    type=str,
    help="The name of a subscription. Supply either this or --management-group",
)
@optgroup.option(
    "--management-group",
    type=str,
    help="The name of a management group. Supply either this or --subscription",
)
@optgroup.group(
    "Other options",
    help="",
)
@optgroup.option(
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
    config_file: str,
    parameters_config_file: str,
    no_params: bool,
    params_optional: bool,
    params_required: bool,
    subscription: str,
    management_group: str,
    enforcement_mode: bool,
    no_summary: bool,
    verbosity: int,
):
    """
    Get Azure Policies
    """
    set_log_level(verbosity)

    if not config_file:
        logger.info(
            "You did not supply an config file. Consider creating one to exclude different policies. We will use the default one."
        )
        config = get_default_config(exclude_services=exclude_services)
    else:
        config = get_config_from_file(
            config_file=config_file, exclude_services=exclude_services
        )

    if subscription:
        management_group = ""
    else:
        subscription = ""

    parameter_requirement_str = ""
    if no_params:
        parameter_requirement_str = "NP"
    elif params_required:
        parameter_requirement_str = "PR"
    elif params_optional:
        parameter_requirement_str = "PO"

    # Policy Initiative Category
    category = "Testing"
    audit_only = False

    if service == "all":
        azure_policies = AzurePolicies(service_names=["all"], config=config)
    else:
        azure_policies = AzurePolicies(service_names=[service], config=config)

    if no_params:
        policy_id_pairs = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=True, params_optional=params_optional, params_required=params_required,
            audit_only=audit_only)
        terraform_template = TerraformTemplateNoParams(
            policy_id_pairs=policy_id_pairs,
            subscription_name=subscription,
            management_group=management_group,
            enforcement_mode=enforcement_mode,
            category=category
        )
    else:
        policy_ids_sorted_by_service = azure_policies.get_all_policy_ids_sorted_by_service(
            no_params=no_params, params_optional=params_optional, params_required=params_required,
            audit_only=audit_only)
        if parameters_config_file:
            parameters_config = utils.read_yaml_file(parameters_config_file)
        else:
            parameters_config = None
        categorized_parameters = OverallCategorizedParameters(
            azure_policies=azure_policies,
            parameters_config=parameters_config,
            params_required=params_required,
            params_optional=params_optional,
            audit_only=audit_only
        )

        terraform_template = TerraformTemplateWithParamsV5(
            policy_id_pairs=policy_ids_sorted_by_service,
            parameter_requirement_str=parameter_requirement_str,
            categorized_parameters=categorized_parameters,
            subscription_name=subscription,
            management_group=management_group,
            enforcement_mode=enforcement_mode,
            category=category
        )
    result = terraform_template.rendered()
    print(result)

    if not no_summary:

        def markdown_summary(file_prefix: str) -> str:
            # Write Markdown summary
            markdown_table = azure_policies.markdown_table(no_params=no_params, params_optional=params_optional, params_required=params_required)
            markdown_file_name = f"{file_prefix}.md"
            if os.path.exists(markdown_file_name):
                if verbosity >= 1:
                    utils.print_grey(f"Removing the previous file: {markdown_file_name}")
                os.remove(markdown_file_name)
            with open(markdown_file_name, "w") as f:
                f.write(markdown_table)
            return markdown_file_name

        parameter_requirement_str = f"{parameter_requirement_str}-{service}-table"

        # Write Markdown summary
        markdown_file = markdown_summary(file_prefix=parameter_requirement_str)

        if verbosity >= 1:
            utils.print_grey(f"Markdown file written to: {markdown_file}")

        # Write CSV summary
        csv_file = f"{parameter_requirement_str}.csv"
        azure_policies.csv_summary(csv_file, verbosity=verbosity, no_params=no_params, params_optional=params_optional, params_required=params_required)
