import os
import re
import json
import csv
from pathlib import Path
from colorama import Fore
END = "\033[0m"
GREY = "\33[90m"

AZURE_POLICY_SERVICE_DIRECTORY = os.path.abspath(
    os.path.join(
        str(Path(os.path.dirname(__file__))),
        "azure-policy",
        "built-in-policies",
        "policyDefinitions"
    )
)

PREFIX = "GrdRlz"


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


def chomp_keep_single_spaces(string):
    """This chomp cleans up all white-space, not just at the ends"""
    string = str(string)
    result = string.replace("\n", " ")  # Convert line ends to spaces
    result = re.sub(" [ ]*", " ", result)  # Truncate multiple spaces to single space
    result = result.replace(" ", " ")  # Replace weird spaces with regular spaces
    result = result.replace(u"\xa0", u" ")  # Remove non-breaking space
    result = re.sub("^[ ]*", "", result)  # Clean start
    return re.sub("[ ]*$", "", result)  # Clean end


def get_compliance_table() -> list:
    compliance_data = os.path.join(os.path.dirname(__file__), "data", "results.csv")
    results = []
    with open(compliance_data) as csv_file:
        csv_reader = csv.DictReader(csv_file, delimiter=',')
        for row in csv_reader:
            results.append(row)
    return results


def print_red(string):
    print(f"{Fore.RED}{string}{END}")


def print_grey(string):
    print(f"{GREY}{string}{END}")
    # Color code from here: https://stackoverflow.com/a/39452138
