#! /usr/bin/env python
import click
from azure_guardrails import command
from azure_guardrails.bin.version import __version__


@click.group()
@click.version_option(version=__version__)
def azure_guardrails():
    """
    Generates Azure Policies based on requirements and transforms them into Terraform.
    """


azure_guardrails.add_command(command.list_policies.list_policies)
azure_guardrails.add_command(command.list_services.list_services)
azure_guardrails.add_command(command.create_exclusions_file.create_exclusions_file)
azure_guardrails.add_command(command.generate_terraform.generate_terraform)


def main():
    """
    Generates Azure Policies based on requirements and transforms them into Terraform.
    """
    azure_guardrails()


if __name__ == "__main__":
    main()
