#! /usr/bin/env python
# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import click
from cloud_guardrails import command
from cloud_guardrails.bin.version import __version__


@click.group()
@click.version_option(version=__version__)
def cloud_guardrails():
    """
    Generates Azure Policies based on requirements and transforms them into Terraform.
    """


cloud_guardrails.add_command(command.create_parameters_file.create_parameters_file)
cloud_guardrails.add_command(command.create_config_file.create_config_file)
cloud_guardrails.add_command(command.describe_policy.describe_policy)
cloud_guardrails.add_command(command.generate_terraform.generate_terraform)
cloud_guardrails.add_command(command.list_policies.list_policies)
cloud_guardrails.add_command(command.list_services.list_services)


def main():
    """
    Generates Azure Policies based on requirements and transforms them into Terraform.
    """
    cloud_guardrails()


if __name__ == "__main__":
    main()
