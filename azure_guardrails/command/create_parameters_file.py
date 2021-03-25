"""
Create a file where we store the values of parameters.
"""

import os
import logging
from pathlib import Path
import click
from azure_guardrails import set_log_level

logger = logging.getLogger(__name__)


@click.command(name="create-parameters-file", short_help="")
@click.option(
    "--output-file",
    "-o",
    type=click.Path(exists=False),
    required=True,
    default="config.yml",
    help="The path to the output file",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def create_config_file(output_file: str, verbosity: int):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)

    config_template = get_config_template()

    filename = Path(output_file).resolve()
    if os.path.exists(output_file):
        print("File exists. Removing...")
        os.remove(output_file)
    with open(filename, "a") as file_obj:
        for line in config_template:
            file_obj.write(line)
    print(f"Created config file: {filename}")
