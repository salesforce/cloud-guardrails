# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import click
import os
import json
from azure_guardrails.shared import utils
from azure_guardrails.scrapers.parse_builtin_definitions import create_azure_builtin_definition


@click.command(
    short_help='Update the single file containing data on all the Azure Policy Definitions.'
)
def update_iam_definition():
    results = create_azure_builtin_definition()
    results_path = os.path.join(utils.DATA_FILE_DIRECTORY, "iam-definition.json")
    if os.path.exists(results_path):
        print("File already exists; removing")
        os.remove(results_path)
    with open(results_path, "w") as file:
        json.dump(results, file, indent=4)
    print(f"Wrote the new IAM definition to: {results_path}")


if __name__ == '__main__':
    update_iam_definition()
