# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import os
from cloud_guardrails.shared import utils
from jinja2 import Template, Environment, FileSystemLoader

DEFAULT_CONFIG_FILE = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "config-template.yml.j2")
)


def get_config_template() -> str:
    template_contents = dict(
        match_only_keywords=[],
        exclude_keywords=[],
        service_names=utils.get_service_names(),
    )
    template_path = os.path.join(os.path.dirname(__file__))
    env = Environment(loader=FileSystemLoader(template_path))  # nosec
    template = env.get_template("config-template.yml.j2")
    return template.render(t=template_contents)
