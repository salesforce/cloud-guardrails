import unittest
from azure_guardrails.shared import utils
from azure_guardrails.logic.terraform import get_terraform_template
from azure_guardrails.logic.services import Services, Service


class TerraformTestCase(unittest.TestCase):
    def test_terraform_single_service(self):
        service = Service(service_name="Key Vault")
        policy_names = service.get_display_names_sorted_by_service(with_parameters=False)
        policy_set_name = "test"
        subscription_name = "example-subscription"
        management_group = ""
        enforcement_mode = False
        result = get_terraform_template(name=policy_set_name, policy_names=policy_names, subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
        # print(result)

    def test_terraform_all_services(self):
        services = Services()
        policy_set_name = "test"
        subscription_name = "example-subscription"
        management_group = ""
        enforcement_mode = False
        display_names = services.get_display_names_sorted_by_service(with_parameters=False)
        result = get_terraform_template(name=policy_set_name, policy_names=display_names, subscription_name=subscription_name,
                                        management_group=management_group, enforcement_mode=enforcement_mode)
        # print(result)
