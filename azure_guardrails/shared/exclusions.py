import os
import logging
import json
import yaml
from jinja2 import Template, Environment, FileSystemLoader
from azure_guardrails.shared import utils

logger = logging.getLogger(__name__)

EXCLUSIONS_TEMPLATE = """# Specify Azure Policy Definition displayNames that you want to exclude from the results
{% for service in service_names %}
{{ service }}:
  - ""
{% endfor %}
"""

DEFAULT_EXCLUSIONS_FILE = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    "default-exclusions.yml"
))


def get_exclusions_template() -> str:
    template = Template(EXCLUSIONS_TEMPLATE)
    return template.render(service_names=utils.get_service_names())


def get_new_exclusions_template() -> str:
    template_contents = dict(
        match_only_keywords=[],
        service_names=utils.get_service_names(),
    )
    template_path = os.path.join(os.path.dirname(__file__))
    env = Environment(loader=FileSystemLoader(template_path))  # nosec
    template = env.get_template("default-exclusions.yml")
    return template.render(t=template_contents)


DEFAULT_EXCLUSIONS_CFG = get_exclusions_template()


class Exclusions:
    def __init__(self, exclude_policies: dict, match_only_keywords: list = None, exclude_services: list = None):
        self.supported_services = utils.get_service_names()  # This is not really needed by the object - just used for data validation

        self.exclude_policies = self._exclude_policies(exclude_policies)
        if not match_only_keywords:
            self.match_only_keywords = []
        else:
            self.match_only_keywords = [x.lower() for x in match_only_keywords]

        # Get the list of services excluded by the user
        self.exclude_services = self._exclude_services(exclude_services)

    def __str__(self):
        # Print the json dumps
        result = dict(
            match_only_keywords=self.match_only_keywords,
            exclude_services=self.exclude_services,
            exclude_policies=self.exclude_policies
        )
        return json.dumps(result)

    def _exclude_policies(self, policies_dict: dict = None) -> dict:
        if policies_dict:
            # Let's just loop through and validate the service names.
            for key, value in policies_dict.items():
                if key not in self.supported_services:
                    raise Exception("Error: the provided service %s is not in the list of supported services")
            return policies_dict
        else:
            return {}

    def _exclude_services(self, services: list = None) -> list:
        exclude_services = []
        if services:
            for service in services:
                if service in self.supported_services:
                    exclude_services.append(service)
                else:
                    raise Exception("Error: the provided service %s is not in the list of supported services")
        return exclude_services

    def is_keyword_match(self, policy_display_name: str) -> bool:
        result = False
        lowercase_name = policy_display_name.lower()
        if self.match_only_keywords:
            for keyword in self.match_only_keywords:
                if keyword in lowercase_name:
                    result = True
                    break
        return result

    def is_policy_excluded(self, service_name: str, display_name: str) -> bool:
        result = False
        # If there is no list of excluded policies, it's not excluded
        if not self.exclude_policies:
            return result

        # If the service name is not in the list of excluded policies at all, then it's not excluded
        service_exists = self.exclude_policies.get(service_name, None)
        if not service_exists:
            return False

        # If the service name is listed, let's loop through the items under each service and see if the text matches.
        for service_name, service_policies in self.exclude_policies.items():
            if display_name in service_policies:
                result = True
                break
        return result

    def is_excluded(self, service_name: str, display_name: str) -> bool:
        # Case: Service is listed in excluded services
        if service_name in self.exclude_services:
            return True
        # Case: substrings from match_only_keywords are in the display name
        elif self.is_keyword_match(policy_display_name=display_name):
            return True
        # Case: The policy name is in the list of excluded policies, sorted by service
        elif self.is_policy_excluded(service_name=service_name, display_name=display_name):
            return True
        else:
            return False


def get_exclusions_from_file(exclusions_file: str) -> Exclusions:
    with open(exclusions_file, "r") as yaml_file:
        try:
            exclusions_cfg = yaml.safe_load(yaml_file)
        except yaml.YAMLError as exc:
            logger.critical(exc)
    exclude_policies = exclusions_cfg.get("exclude_policies", None)
    exclude_services = exclusions_cfg.get("exclude_services", None)
    match_only_keywords = exclusions_cfg.get("match_only_keywords", None)
    exclusions = Exclusions(exclude_policies=exclude_policies, exclude_services=exclude_services, match_only_keywords=match_only_keywords)
    return exclusions
