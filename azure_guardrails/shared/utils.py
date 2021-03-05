import os
import json
import yaml
from pathlib import Path
from jinja2 import Template
from colorama import Fore
END = "\033[0m"

AZURE_POLICY_SERVICE_DIRECTORY = os.path.abspath(
    os.path.join(
        str(Path(os.path.dirname(__file__))),
        "azure-policy",
        "built-in-policies",
        "policyDefinitions"
    )
)

EXCLUSIONS_TEMPLATE = """# Specify Azure Policy Definition displayNames that you want to exclude from the results
{% for service in service_names %}
{{ service }}:
  - ""
{% endfor %}
"""


def get_exclusions_template() -> str:
    template = Template(EXCLUSIONS_TEMPLATE)
    return template.render(service_names=get_service_names())


def get_service_names():
    services = os.listdir(AZURE_POLICY_SERVICE_DIRECTORY)
    services.sort()
    # TODO: Removing Azure Government because it has nested folders. Need to handle this case later.
    services.remove("Azure Government")
    # Regulatory compliance is full of Microsoft Managed Controls
    services.remove("Regulatory Compliance")
    return services


def read_json_file(file: str) -> dict:
    with open(file) as f:
        contents = f.read()
        try:
            results = json.loads(contents)
        except json.decoder.JSONDecodeError as error:
            decoded_data = contents.encode().decode('utf-8-sig')
            results = json.loads(decoded_data)
    return results


def get_policy_json(service_name: str, filename: str):
    file = os.path.join(AZURE_POLICY_SERVICE_DIRECTORY, service_name, filename)
    contents = read_json_file(file)
    return contents


def print_red(string):
    print(f"{Fore.RED}{string}{END}")
