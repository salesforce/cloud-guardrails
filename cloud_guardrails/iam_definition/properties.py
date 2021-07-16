# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import json
from cloud_guardrails.iam_definition.parameter import Parameter


class Properties:
    def __init__(self, properties_json: dict):
        self.properties_json = properties_json
        # Values
        display_name = properties_json.get("displayName")
        self.policy_type = properties_json.get("policyType")
        self.mode = properties_json.get("mode")
        self.description = properties_json.get("description")

        # Metadata
        self.metadata_json = properties_json.get("metadata")
        self.version = self.metadata_json.get("version", None)
        self.category = self.metadata_json.get("category", None)
        self.preview = self.metadata_json.get("preview", None)
        # if self.preview:
        #     # # Sometimes, Preview is already in the display name. For example, "[ASC Private Preview] Deploy - Configure system-assigned managed identity to enable Azure Monitor assignments on VMs"
        #     # if "Preview" not in display_name:
        #     #     self.display_name = f"[Preview]: {display_name}"
        #     # # If the word 'Preview' is already in the display name, leave it
        #     # else:
        #     #     self.display_name = display_name
        # else:
        if "[Preview]: " in display_name:
            display_name.replace("[Preview]: ", "")
        self.display_name = display_name
        self.deprecated = self.metadata_json.get("deprecated", None)

        # PolicyDefinition Rule and Parameters
        self.policy_rule = properties_json.get("policyRule")
        self.parameters = self._parameters(properties_json.get("parameters"))

    def __repr__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            policy_type=self.policy_type,
            mode=self.mode,
            description=self.description,
            version=self.version,
            preview=self.version,
            display_name=self.version,
            deprecated=self.version,
            policy_rule=self.version,
        )
        if self.parameters:
            parameters_result = {}
            for parameter in self.parameters:
                parameters_result[parameter.name] = parameter.json()
            result["parameters"] = parameters_result
        return result

    def _parameters(self, parameters_json: dict) -> dict:
        parameters = {}
        if parameters_json:
            for name, value in parameters_json.items():
                parameter = Parameter(name=name, parameter_json=value)
                parameters[name] = parameter
        return parameters

    @property
    def parameter_names(self) -> list:
        if self.parameters:
            return list(self.parameters.keys())
        else:
            return []

    @property
    def parameter_json(self) -> dict:
        result = {}
        if self.parameters:
            for name, value in self.parameters.items():
                result[name] = value.json()
            return result
        else:
            return {}
