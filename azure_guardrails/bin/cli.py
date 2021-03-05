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


azure_guardrails.add_command(command.get_policies.get_policies)


def main():
    """
    Generates Azure Policies based on requirements and transforms them into Terraform.
    """
    azure_guardrails()


if __name__ == "__main__":
    main()
