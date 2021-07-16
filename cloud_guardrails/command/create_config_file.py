# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""Create a config file to specify which policies to select or exclude."""
import os
import logging
from pathlib import Path
import click
from cloud_guardrails import set_log_level
from cloud_guardrails.shared.config import get_config_template

logger = logging.getLogger(__name__)


@click.command(
    name="create-config-file",
    short_help="Create a config file to specify which policies to select or exclude."
)
@click.option("--output", "-o", "output_file", type=click.Path(exists=False), required=True, default="config.yml", help="The path to the output file",)
@click.option("--verbose", "-v", "verbosity", count=True)
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
