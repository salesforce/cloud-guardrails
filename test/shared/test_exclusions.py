import unittest
import yaml
import logging
from azure_guardrails.shared import utils
from azure_guardrails.shared.exclusions import get_exclusions_template, Exclusions, get_exclusions_from_file

logger = logging.getLogger(__name__)


class ExclusionsTestCase(unittest.TestCase):
    def test_default_exclusions_template(self):
        result = get_exclusions_template()
        print(result)

    def test_exclusions_object(self):
        exclude_policies = {}
        match_only_keywords = []
        exclude_services = []
        exclusions = Exclusions(exclude_policies=exclude_policies, match_only_keywords=match_only_keywords, exclude_services=exclude_services)
        # print(exclusions.__str__())
        self.assertTrue(exclusions.__str__() == '{"match_only_keywords": [], "exclude_services": [], "exclude_policies": {}}')

    def test_exclusions_methods(self):
        exclude_policies = {
            "General": [
                "Allow resource creation only in Asia data centers"
            ]
        }
        match_only_keywords = ["Encrypt"]
        exclude_services = ["Key Vault"]
        exclusions = Exclusions(exclude_policies=exclude_policies, match_only_keywords=match_only_keywords, exclude_services=exclude_services)
        # Case: Is service name excluded
        self.assertTrue(exclusions.is_excluded("Key Vault", "blah"))
        # Case: Match only keywords
        self.assertTrue(exclusions.is_excluded("Automation", "Encrypt stuff"))
        self.assertTrue(exclusions.is_excluded("Automation", "do encrypt"))
        # Case: Exclude Policies
        self.assertTrue(exclusions.is_excluded("General", "Allow resource creation only in Asia data centers"))
        self.assertFalse(exclusions.is_excluded("General", "Allow resource creation only in India data centers"))

    # def test_read_exclusions_file(self):
    #     print(DEFAULT_EXCLUSIONS_FILE)
    #     exclusions = get_exclusions_from_file(DEFAULT_EXCLUSIONS_FILE)
    #     print(exclusions.__str__())

    def test_read_exclusions(self):
        default_exclusions = get_exclusions_template()
        print(default_exclusions)
