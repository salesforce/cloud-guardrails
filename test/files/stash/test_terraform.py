# import unittest
# import json
# from cloud_guardrails.shared import utils
# from cloud_guardrails.terraform.terraform import TerraformTemplateNoParams
# from cloud_guardrails.iam_definition.services import Services, Service
#
#
# class TerraformTemplateNoParamsTestCase(unittest.TestCase):
#     def test_terraform_single_service(self):
#         service = Services(service_names=["Key Vault"])
#         policy_names = service.get_display_names_sorted_by_service_no_params()
#         subscription_name = "example"
#         management_group = ""
#         enforcement_mode = False
#         terraform_template = TerraformTemplateNoParams(policy_names=policy_names, subscription_name=subscription_name,
#                                                        management_group=management_group,
#                                                        enforcement_mode=enforcement_mode)
#         result = terraform_template.rendered()
#         print(result)
#         self.assertListEqual(list(terraform_template.policy_names.keys()), ["Key Vault"])
#         self.assertTrue("Key vaults should have soft delete enabled" in terraform_template.policy_names.get("Key Vault"))
#         self.assertTrue("example_noparams" in result)
#
#     def test_terraform_all_services(self):
#         services = Services()
#         subscription_name = "example"
#         management_group = ""
#         enforcement_mode = False
#         policy_names = services.get_display_names_sorted_by_service_no_params()
#         terraform_template = TerraformTemplateNoParams(policy_names=policy_names, subscription_name=subscription_name,
#                                                        management_group=management_group,
#                                                        enforcement_mode=enforcement_mode)
#         result = terraform_template.rendered()
#         policy_name_keys = list(terraform_template.policy_names.keys())
#         all_services = utils.get_service_names()
#         print(f"Length of Policy name keys: {len(policy_name_keys)}")
#         print(f"Length of All Services list: {len(all_services)}")
#         self.assertTrue(len(policy_name_keys) >= 39)
#         for service in policy_name_keys:
#             self.assertTrue(service in all_services)
#         # print(result)
#
