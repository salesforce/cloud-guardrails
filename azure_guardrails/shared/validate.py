import logging
import click
from azure_guardrails.shared import utils


def click_validate_supported_azure_service(ctx, param, value):
    supported_services = utils.get_service_names()
    supported_services.append("all")

    if value in supported_services:
        return value
    else:
        raise click.BadParameter(
            f"Supply a supported Azure service. Supported services are: {', '.join(supported_services)}"
        )
