# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import os
import json
import copy
from cloud_guardrails.shared import utils
from cloud_guardrails.iam_definition.policy_definition import PolicyDefinition
default_service_names = utils.get_service_names()
default_service_names.sort()


def get_service_policy_files(service_policy_directory: str) -> list:
    policy_files = [
        f
        for f in os.listdir(service_policy_directory)
        if os.path.isfile(os.path.join(service_policy_directory, f))
    ]
    policy_files.sort()
    return policy_files


def create_azure_builtin_definition() -> dict:
    results = {
        "service_definitions": {},
        "policy_definitions": {}
    }
    for service_name in default_service_names:
        # Get paths for all the policy files for that service
        service_policy_directory = os.path.join(
            utils.AZURE_POLICY_SERVICE_DIRECTORY, service_name
        )
        policy_files = get_service_policy_files(service_policy_directory)
        # Add the service to the service definitions
        results["service_definitions"][service_name] = {}

        for policy_file_name in policy_files:
            policy_content = utils.read_json_file(str(os.path.join(service_policy_directory, policy_file_name)))
            policy_definition = PolicyDefinition(
                policy_content=policy_content, service_name=service_name, file_name=str(policy_file_name)
            )
            # Look up by unique ID, like "051cba44-2429-45b9-9649-46cec11c7119"
            short_id = policy_definition.name

            # Add to service_definitions
            service_definition_entry = dict(
                display_name=policy_definition.display_name,
                short_id=short_id,
                service_name=policy_definition.service_name,
                description=policy_definition.properties.description,
                github_link=policy_definition.github_link,
                file_name=policy_file_name,
                allowed_effects=policy_definition.allowed_effects,
                no_params=policy_definition.no_params,
                params_optional=policy_definition.params_optional,
                params_required=policy_definition.params_required,
                is_deprecated=policy_definition.is_deprecated,
                audit_only=policy_definition.audit_only,
                modifies_resources=policy_definition.modifies_resources,
                parameter_names=policy_definition.parameter_names,
            )
            results["service_definitions"][service_name][short_id] = service_definition_entry

            # Add to policy_definitions
            policy_definition_entry = copy.deepcopy(service_definition_entry)
            policy_definition_entry["policy_content"] = policy_content
            results["policy_definitions"][short_id] = policy_definition_entry
    return results
