from azure_guardrails.shared import utils


class TerraformTemplateWithParamsV4:
    """Terraform Template with Parameters"""
    def __init__(
            self,
            policy_id_pairs: dict,
            parameter_requirement_str: str,
            subscription_name: str = "",
            management_group: str = "",
            enforcement_mode: bool = False,
            category: str = "Testing"
    ):
        self.enforce = enforcement_mode
        self.name = self._initiative_name(
            subscription_name=subscription_name, management_group=management_group,
            parameter_requirement_str=parameter_requirement_str
        )
        self.service_parameters = self._parameters(policy_id_pairs)
        self.subscription_name = subscription_name
        self.management_group = management_group
        self.category = category
        self.policy_id_pairs = self._policy_id_pairs(policy_id_pairs)
        if enforcement_mode:
            self.enforcement_string = "true"
        else:
            self.enforcement_string = "false"

    def _initiative_name(self, subscription_name: str, management_group: str, parameter_requirement_str: str) -> str:
        if subscription_name == "" and management_group == "":
            raise Exception(
                "Please supply a value for the subscription name or the management group"
            )
        if self.enforce:
            parameter_requirement_str = f"{parameter_requirement_str}-Enforce"
        else:
            parameter_requirement_str = f"{parameter_requirement_str}-Audit"
        if subscription_name:
            initiative_name = utils.format_policy_name(subscription_name, parameter_requirement_str)
        else:
            initiative_name = utils.format_policy_name(management_group, parameter_requirement_str)
        return initiative_name

    @staticmethod
    def _policy_id_pairs(policy_id_pairs) -> dict:
        # Just validate the input, that's all
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
