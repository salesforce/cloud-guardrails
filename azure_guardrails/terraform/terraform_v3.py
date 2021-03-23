import os
from jinja2 import Template, Environment, FileSystemLoader
from azure_guardrails.shared import utils


class TerraformTemplateNoParamsV3:
    """Terraform Template for when there are no parameters"""

    def __init__(
        self,
        policy_id_pairs: dict,
        subscription_name: str = "",
        management_group: str = "",
        enforcement_mode: bool = False,
    ):
        self.name = "noparams"
        self.initiative_name = self._initiative_name(
            subscription_name=subscription_name, management_group=management_group
        )
        self.subscription_name = subscription_name
        self.management_group = management_group
        self.policy_id_pairs = self._policy_id_pairs(policy_id_pairs)
        if enforcement_mode:
            self.enforcement_string = "true"
        else:
            self.enforcement_string = "false"
        self.category = "Testing"

    @staticmethod
    def _initiative_name(subscription_name: str, management_group: str) -> str:
        if subscription_name == "" and management_group == "":
            raise Exception(
                "Please supply a value for the subscription name or the management group"
            )
        if subscription_name:
            # shorten the name if it is over a certain length to avoid hitting limits
            if len(subscription_name) > 55:
                subscription_name = subscription_name[0:54]
            initiative_name = f"{subscription_name}-noparams"
        else:
            if len(management_group) > 55:
                management_group = management_group[0:54]
            initiative_name = f"{management_group}-noparams"
        initiative_name = initiative_name.replace("-", "_")
        initiative_name = initiative_name.lower()
        return initiative_name

    def _policy_id_pairs(self, policy_id_pairs: dict) -> dict:
        example_input = {
            "API for FHIR": {
                "051cba44-2429-45b9-9649-46cec11c7119": {
                    "display_name": "Azure API for FHIR should use a customer-managed key to encrypt data at rest",
                    "short_id": "051cba44-2429-45b9-9649-46cec11c7119"
                },
                "1ee56206-5dd1-42ab-b02d-8aae8b1634ce": {
                    "display_name": "Azure API for FHIR should use private link",
                    "short_id": "1ee56206-5dd1-42ab-b02d-8aae8b1634ce"
                }
            }
        }
        all_valid_services = utils.get_service_names()
        for service_name, service_policies in policy_id_pairs.items():
            if service_name not in all_valid_services:
                raise Exception("The service provided is not a valid service")
            for policy_id, policy_details in service_policies.items():
                if not policy_details.get("display_name", None):
                    raise Exception("There should be a display name")
                if not policy_details.get("short_id", None):
                    raise Exception("There should be a short_id")
        return policy_id_pairs

    def rendered(self) -> str:
        template_contents = dict(
            name=self.name,
            initiative_name=self.initiative_name,
            policy_id_pairs=self.policy_id_pairs,
            subscription_name=self.subscription_name,
            management_group=self.management_group,
            enforcement_mode=self.enforcement_string,
            category=self.category
        )
        template_path = os.path.join(os.path.dirname(__file__), "no-parameters-v3")
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        template = env.get_template("policy-initiative-no-params.tf")
        return template.render(t=template_contents)
