import os
import unittest
import yaml
import json
from yaml.constructor import ConstructorError
import logging
from cloud_guardrails.shared import utils
from cloud_guardrails.shared.config import get_config_template, Config, get_config_from_file, get_default_config

logger = logging.getLogger(__name__)
example_config_file = os.path.abspath(os.path.join(
    os.path.dirname(__file__),
    os.path.pardir,
    "files",
    "example-config.yml"
))


class ConfigTestCase(unittest.TestCase):
    def test_default_config_template(self):
        result = get_config_template()
        # print(result)

    def test_config_object(self):
        exclude_policies = {}
        match_only_keywords = []
        exclude_services = []
        config = Config(exclude_policies=exclude_policies, match_only_keywords=match_only_keywords, exclude_services=exclude_services)
        # print(config.__str__())
        self.assertTrue(config.__str__() == '{"match_only_keywords": [], "exclude_services": [], "exclude_policies": {}}')

    def test_config_methods(self):
        exclude_policies = {
            "General": [
                "Allow resource creation only in Asia data centers"
            ]
        }
        match_only_keywords = []
        exclude_services = ["Key Vault"]
        config = Config(exclude_policies=exclude_policies, match_only_keywords=match_only_keywords, exclude_services=exclude_services)
        # Case: Is service name excluded
        self.assertTrue(config.is_excluded("Key Vault", "blah"))
        # Case: Match only keywords
        self.assertFalse(config.is_excluded("Automation", "Encrypt stuff"))
        self.assertFalse(config.is_excluded("Automation", "do encrypt"))
        # Case: Exclude Policies
        self.assertTrue(config.is_excluded("General", "Allow resource creation only in Asia data centers"))
        self.assertFalse(config.is_excluded("General", "Allow resource creation only in India data centers"))

    def test_config_when_match_keyword_is_used(self):
        exclude_policies = {
            "General": [
                "Allow resource creation only in Asia data centers"
            ]
        }
        match_only_keywords = ["Encrypt"]
        exclude_services = ["Key Vault"]
        config = Config(exclude_policies=exclude_policies, match_only_keywords=match_only_keywords, exclude_services=exclude_services)
        # Case: Is service name excluded
        self.assertTrue(config.is_excluded("Key Vault", "blah"))
        # Case: Match only keywords
        self.assertFalse(config.is_excluded("Automation", "Encrypt stuff"))

        # These ones will all fail because they don't explicitly match the required keywords
        self.assertTrue(config.is_excluded("Automation", "HotDogsAreSandwiches"))
        self.assertTrue(config.is_excluded("General", "Allow resource creation only in Asia data centers"))
        self.assertTrue(config.is_excluded("General", "Allow resource creation only in India data centers"))

    def test_read_config_file(self):
        # print(example_config_file)
        config = get_config_from_file(example_config_file)
        # print(config.__str__())
        # print(json.dumps(config.json(), indent=4))
        keys = list(config.json().keys())
        self.assertListEqual(keys, ['match_only_keywords', 'exclude_services', 'exclude_policies'])

    def test_read_config(self):
        default_config_template = get_config_template()
        # print(default_config_template)

    def test_default_config(self):
        config = get_default_config()
        # print(config)

    def test_exclude_keywords_config(self):
        config = get_default_config(exclude_keywords=["private link"])
        self.assertTrue(config.is_excluded("API for FHIR", "Azure API for FHIR should use private link"))
        self.assertTrue(config.is_excluded("App Configuration", "App Configuration should use private link"))
        self.assertTrue(config.is_excluded("Cosmos DB", "CosmosDB accounts should use private link"))

    def test_exclude_services_config(self):
        config = get_default_config(exclude_services=["Guest Configuration"])
        response = config.is_service_excluded(service_name="Guest Configuration")
        print(response)
        self.assertTrue(response)


    def test_gh_44_bad_config_file(self):
        bad_config_file = os.path.abspath(os.path.join(
            os.path.dirname(__file__),
            os.path.pardir,
            "files",
            "bad-config.yml"
        ))
        with self.assertRaises(yaml.constructor.ConstructorError):
            config = get_config_from_file(bad_config_file)
