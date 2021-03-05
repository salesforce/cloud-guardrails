import os
import json
from azure_guardrails.shared import constants


def get_service_names():
    services = os.listdir(constants.AZURE_POLICY_SERVICE_DIRECTORY)
    services.sort()
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
    file = os.path.join(constants.AZURE_POLICY_SERVICE_DIRECTORY, service_name, filename)
    contents = read_json_file(file)
    return contents
