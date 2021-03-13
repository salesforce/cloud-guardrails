import os
import json
import logging
from typing import List, Dict, Optional
from azure_guardrails.shared import utils
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config
from azure_guardrails.guardrails.policy_definition_v2 import PolicyDefinitionV2, ParameterV2

logger = logging.getLogger(__name__)


class ServiceV2:
    def __init__(self, service_name: str, config: Config = DEFAULT_CONFIG):
        self.service_name = service_name
        self.config = config
        service_policy_directory = os.path.join(utils.AZURE_POLICY_SERVICE_DIRECTORY, self.service_name)
        self.policy_files = self._policy_files(service_policy_directory)
        self.policy_definitions = self._policy_definitions()

    def __repr__(self):
        return json.dumps(self.json())

    def json(self) -> dict:
        result = dict(
            service_name=self.service_name,
            # display_names=self.display_names,
        )

        if self.policy_definitions:
            policy_definitions_result = {}
            for policy_definition, policy_definition_details in self.policy_definitions.items():
                policy_definitions_result[policy_definition] = policy_definition_details.json()
            result["policy_definitions"] = policy_definitions_result
        return result

    def _policy_files(self, service_policy_directory: str) -> list:
        policy_files = [f for f in os.listdir(service_policy_directory) if os.path.isfile(os.path.join(service_policy_directory, f))]
        policy_files.sort()
        return policy_files

    # def _policy_definitions(self) -> Dict[Optional[PolicyDefinitionV2]]:
    def _policy_definitions(self) -> dict:
        # def _policy_definitions(self) -> Dict[Optional[PolicyDefinition]]:
        policy_definitions = {}
        for file in self.policy_files:
            policy_content = utils.get_policy_json(service_name=self.service_name, filename=file)
            policy_definition = PolicyDefinitionV2(policy_content=policy_content, service_name=self.service_name)
            policy_definitions[policy_definition.display_name] = policy_definition
        return policy_definitions

    def skip_display_names(self, policy_definition: PolicyDefinitionV2) -> bool:
        # Quality control
        # First, if the display name starts with [Deprecated], skip it
        if policy_definition.display_name.startswith("[Deprecated]: "):
            logger.debug("Deprecated Policy; skipping. Policy name: %s" % policy_definition.display_name)
            return True
        # Some Policies with Modify capabilities don't have an Effect - only way to detect them is to see if the name starts with 'Deploy'
        elif policy_definition.display_name.startswith("Deploy "):
            logger.debug("'Deploy' Policy detected; skipping. Policy name: %s" % policy_definition.display_name)
            return True
        # If the policy is deprecated, skip it
        elif policy_definition.is_deprecated:
            logger.debug("Policy definition is deprecated; skipping. Policy name: %s" % policy_definition.display_name)
            return True
        # If we have specified it in the Config config, skip it
        elif self.config.is_excluded(service_name=self.service_name, display_name=policy_definition.display_name):
            logger.debug("Policy definition is excluded; skipping. Policy name: %s" % policy_definition.display_name)
            return True
        else:
            return False

    @property
    def display_names(self) -> list:
        display_names = list(self.policy_definitions.keys())
        display_names.sort()
        return display_names

    @property
    def display_names_no_params(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.no_params:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    @property
    def display_names_params_optional(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.params_optional:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    @property
    def display_names_params_required(self) -> list:
        display_names = []
        for display_name, policy_definition in self.policy_definitions.items():
            if not self.skip_display_names(policy_definition=policy_definition):
                if policy_definition.params_required:
                    display_names.append(display_name)
        display_names.sort()
        return display_names

    def get_policy_definition_parameters(self, display_name: str, params_required: bool = False) -> dict:
        parameters = {}
        for this_display_name, policy_definition in self.policy_definitions.items():
            if this_display_name == display_name:
                # Params required
                if params_required and policy_definition.params_required:
                    for parameter_name, parameter_details in policy_definition.parameters.items():
                        if parameter_details.name == "effect":
                            continue
                        parameters[parameter_details.name] = parameter_details.json()
                    continue
                # Params Optional
                if not params_required and policy_definition.params_optional:
                    for parameter_name, parameter_details in policy_definition.parameters.items():
                        if parameter_details.name == "effect":
                            continue
                        parameters[parameter_details.name] = parameter_details.json()
                    continue
        return parameters


class ServicesV2:
    default_service_names = utils.get_service_names()
    default_service_names.sort()

    def __init__(self, service_names: list = default_service_names, config: Config = DEFAULT_CONFIG):
        if service_names == ["all"]:
            service_names = utils.get_service_names()
            service_names.sort()
        self.service_names = service_names
        self.config = config
        self.services = self._services()

    def _services(self) -> dict:
        # def _services(self) -> Dict[Optional[ServiceV2]]:
        services = {}
        service_names = self.service_names
        for service_name in service_names:
            service = ServiceV2(service_name=service_name, config=self.config)
            services[service_name] = service
        return services

    @property
    def display_names_no_params(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_no_params)
        display_names.sort()
        return display_names

    @property
    def display_names_params_optional(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_params_optional)
        display_names.sort()
        return display_names

    @property
    def display_names_params_required(self) -> list:
        display_names = []
        for service_name, service_details in self.services.items():
            display_names.extend(service_details.display_names_params_required)
        display_names.sort()
        return display_names

    def get_display_names_sorted_by_service_no_params(self) -> dict:
        results = {}
        for service_name, service_details in self.services.items():
            logger.debug("Getting display names for service: %s" % service_name)
            this_service_display_names = service_details.display_names_no_params
            this_service_display_names = list(dict.fromkeys(this_service_display_names))  # remove duplicates
            if this_service_display_names:
                results[service_name] = this_service_display_names
        return results

    def get_display_names_sorted_by_service_with_params(self, params_required: bool = False) -> dict:
        results = {}
        for service_name, service_details in self.services.items():
            logger.debug("Getting display names for service: %s" % service_name)
            service_parameters = {}

            # Get the display names depending on whether we are looking for Params Required or Params Optional
            if params_required:
                this_service_display_names = service_details.display_names_params_required
            else:
                this_service_display_names = service_details.display_names_params_optional

            # Loop through the service's display names and get the parameters for each Policy Definition
            for display_name in this_service_display_names:
                parameters = service_details.get_policy_definition_parameters(display_name=display_name, params_required=params_required)
                if parameters:
                    service_parameters[display_name] = parameters
            results[service_name] = service_parameters
        return results
