import logging
from azure_guardrails.shared.config import DEFAULT_CONFIG, Config

from azure_guardrails.shared import utils

default_service_names = utils.get_service_names()
default_service_names.sort()


class ParametersConfig:
    def __init__(
            self,
            service_names: list = default_service_names,
            config: Config = DEFAULT_CONFIG,
    ):
        if service_names == ["all"]:
            service_names = utils.get_service_names()
            service_names.sort()
        self.service_names = service_names
