# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
"""
List services supported by Azure Built-in policies
"""
import logging
import os
import click
from cloud_guardrails import set_log_level
from cloud_guardrails.shared import utils

logger = logging.getLogger(__name__)


@click.command(name="list-services", short_help="List services supported by Azure Built-in policies")
@click.option("-v", "--verbose", "verbosity", count=True)
def list_services(verbosity):
    """List services supported by Azure Built-in policies"""
    set_log_level(verbosity)
    services = utils.get_service_names()
    for service in services:
        print(service)
