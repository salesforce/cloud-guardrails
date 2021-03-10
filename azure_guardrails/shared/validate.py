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


def click_validate_comma_separated_excluded_services(ctx, param, value):
    supported_services = utils.get_service_names()
    if value is not None:
        try:
            if value == "":
                return []
            else:
                excluded_services = value.split(",")
                for service in excluded_services:
                    if service not in supported_services:
                        raise click.BadParameter(f"The service name {service} is invalid. Please provide a comma "
                                                 f"separated list of supported services from the list: "
                                                 f"{','.join(supported_services)}")
                return excluded_services
        except ValueError:
            raise click.BadParameter("Supply the list of resource names to exclude from results in a comma separated string.")
