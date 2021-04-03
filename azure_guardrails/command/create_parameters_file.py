"""
Create a file where we store the values of parameters.
"""

import os
import logging
from pathlib import Path
import click
from click_option_group import optgroup
from azure_guardrails import set_log_level
# from azure_guardrails.shared.parameters_categorized import get_parameters_template
from azure_guardrails.templates.parameters_template import ParameterTemplate
from azure_guardrails.shared import validate
from azure_guardrails.shared.config import get_default_config, get_config_from_file

logger = logging.getLogger(__name__)


@click.command(name="create-parameters-file", short_help="")
@click.option(
    "--output-file",
    "-o",
    type=click.Path(exists=False),
    required=True,
    default="parameters.yml",
    help="The path to the output file",
)
@click.option(
    "--config-file",
    "-c",
    type=click.Path(exists=False),
    required=False,
    # default="config.yml",
    help="The path to the output file",
)
@click.option(
    "--exclude-services",
    "exclude_services",
    type=str,
    help="Exclude specific services (comma-separated) without using a config file.",
    callback=validate.click_validate_comma_separated_excluded_services,
)
@optgroup.group(
    "Parameter Options",
    help="",
)
@optgroup.option(
    "--optional-only",
    "-oo",
    is_flag=True,
    default=False,
    help="Include policies containing OPTIONAL parameters",
)
@optgroup.option(
    "--required-only",
    "-ro",
    is_flag=True,
    default=False,
    help="Include policies containing REQUIRED parameters",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def create_parameters_file(
    output_file: str,
    config_file: str,
    optional_only: bool,
    required_only: bool,
    exclude_services: list,
    verbosity: int
):
    """
    Create a file of parameters to supply to Azure Policies
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

    params_optional = True
    params_required = True
    # If optional_only is set, only leave params_optional to True
    if optional_only:
        params_required = False
    # If required_only is set, only leave params_required to True
    if required_only:
        params_optional = False

    # config_template = get_parameters_template()
    parameters_template = ParameterTemplate(config=config, params_optional=params_optional, params_required=params_required)
    parameters_template_rendered = parameters_template.rendered()

    filename = Path(output_file).resolve()
    if os.path.exists(output_file):
        print("File exists. Removing...")
        os.remove(output_file)
    with open(filename, "a") as file_obj:
        for line in parameters_template_rendered:
            file_obj.write(line)
    print(f"Created config file: {filename}")
