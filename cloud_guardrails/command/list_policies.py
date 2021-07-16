# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""
List available built-in Azure Policies
"""
import logging
import yaml
import click
from click_option_group import optgroup, RequiredMutuallyExclusiveOptionGroup
from cloud_guardrails import set_log_level
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies
from cloud_guardrails.shared import utils, validate

logger = logging.getLogger(__name__)


@click.command(name="list-policies", short_help="List available built-in Azure Policies.")
@click.option("--service", "-s", type=str, required=True, help="Services supported by Azure Policy definitions", callback=validate.click_validate_supported_azure_service)
# Effects
@optgroup.group("Effects", help="")
@optgroup.option("--audit-only", "-a", is_flag=True, required=False, default=False, help="Policies with 'Audit' or 'AuditIfNotExists' effect only")
# Parameter Options
@optgroup.group("Parameter Options", cls=RequiredMutuallyExclusiveOptionGroup, help="")
@optgroup.option("--all-policies", is_flag=True, default=False, help="Show all policies, regardless of whether or not they have parameters")
@optgroup.option("--no-params", is_flag=True, default=False, help="Only generate policies that do NOT require parameters")
@optgroup.option("--params-optional", is_flag=True, default=False, help="Only generate policies where parameters are OPTIONAL")
@optgroup.option("--params-required", is_flag=True, default=False, help="Only generate policies where parameters are REQUIRED")
# Other options=
@optgroup.group("Other Options", help="")
@optgroup.option("--format", "-f", "fmt", type=click.Choice(["stdout", "yaml"]), required=False, default="stdout", help="Output format")
@click.option("--verbose", "-v", "verbosity", count=True,)
def list_policies(
    service: str,
    audit_only: bool,
    all_policies: bool,
    no_params: bool,
    params_optional: bool,
    params_required: bool,
    fmt: str,
    verbosity: int,
):
    """
    List Azure Policies
    """

    set_log_level(verbosity)
    service_names = utils.get_service_names()
    service_names.append("all")
    if service not in service_names:
        raise Exception(
            f"Please provide a valid service name. Valid service names are {service_names}"
        )
    if verbosity >= 1:
        utils.print_grey("Getting policy names according to service\n")
    if fmt == "yaml":
        print_policies_in_yaml(
            service=service,
            audit_only=audit_only,
            all_policies=all_policies,
            no_params=no_params,
            params_optional=params_optional,
            params_required=params_required,
            verbosity=verbosity,
        )
    else:
        print_policies_in_stdout(
            service=service,
            audit_only=audit_only,
            all_policies=all_policies,
            no_params=no_params,
            params_optional=params_optional,
            params_required=params_required,
            verbosity=verbosity,
        )


def get_display_names_sorted_by_service(
        service: str,
        audit_only: bool,
        all_policies: bool,
        no_params: bool,
        params_optional: bool,
        params_required: bool,
) -> dict:
    if service == "all":
        azure_policies = AzurePolicies()
    else:
        azure_policies = AzurePolicies(service_names=[service])
    if all_policies:
        display_names = azure_policies.get_all_display_names_sorted_by_service(no_params=True, params_optional=True, params_required=True, audit_only=audit_only)
    else:
        display_names = azure_policies.get_all_display_names_sorted_by_service(no_params=no_params, params_optional=params_optional, params_required=params_required, audit_only=audit_only)
    if service != "all":
        if display_names.get(service, None):
            trimmed_display_names = {service: display_names[service].copy()}
            display_names = trimmed_display_names.copy()
        else:
            display_names = {service: {}}
    return display_names


def print_policies_in_yaml(
        service: str,
        audit_only: bool,
        all_policies: bool,
        no_params: bool,
        params_optional: bool,
        params_required: bool,
        verbosity: int,
):
    display_names = get_display_names_sorted_by_service(
        service=service,
        audit_only=audit_only,
        all_policies=all_policies,
        no_params=no_params,
        params_optional=params_optional,
        params_required=params_required,
    )
    result = yaml.dump(display_names)
    total_policies = 0
    for service_name in display_names.keys():
        total_policies += len(display_names[service_name])
    print(result)
    if verbosity >= 1:
        print(f"total policies: {str(total_policies)}")


def print_policies_in_stdout(
        service: str,
        audit_only: bool,
        all_policies: bool,
        no_params: bool,
        params_optional: bool,
        params_required: bool,
        verbosity: int,
):

    display_names = get_display_names_sorted_by_service(
        service=service,
        audit_only=audit_only,
        all_policies=all_policies,
        no_params=no_params,
        params_optional=params_optional,
        params_required=params_required,
    )
    total_policies = 0
    for service_name in display_names.keys():
        # print(f"{service_name}:")
        total_policies += len(display_names[service_name])
        for policy_name in display_names.get(service_name):
            print(policy_name)
            # print(f"\t{policy_name}")
        # print("\n")

    if verbosity >= 1:
        print(f"total policies: {str(total_policies)}")
