"""

"""
import os
import logging
import json
from pathlib import Path
import yaml
import click
from azure_guardrails import set_log_level
from azure_guardrails.logic.services import Services, Service
from azure_guardrails.shared import utils, validate

logger = logging.getLogger(__name__)


@click.command(name="create-exclusions-file", short_help="")
@click.option(
    "--output-file",
    "-o",
    type=click.Path(exists=False),
    required=True,
    default="exclusions.yml",
    help="The path to the output file",
)
@click.option(
    "--verbose",
    "-v",
    "verbosity",
    count=True,
)
def create_exclusions_file(output_file: str, verbosity: int):
    """
    Get Azure Policies
    """

    set_log_level(verbosity)

    exclusions_template = utils.get_exclusions_template()

    filename = Path(output_file).resolve()
    if os.path.exists(output_file):
        print("File exists. Removing...")
        os.remove(output_file)
    with open(filename, "a") as file_obj:
        for line in exclusions_template:
            file_obj.write(line)
    print(f"Created exclusions file: {filename}")
