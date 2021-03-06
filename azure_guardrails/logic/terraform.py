import os
from jinja2 import Template, Environment, FileSystemLoader

default_source = "git@github.com:kmcquade/azure-guardrails.git//azure_guardrails/shared/terraform/policy-initiative-with-builtins"


# TODO: Instead of a straight up list, how about we include the service name at the top?
def get_terraform_template(name: str, policy_names: dict, subscription_name: str = "",
                           management_group: str = "", enforcement_mode: bool = False,
                           module_source: str = default_source) -> str:
    if subscription_name == "" and management_group == "":
        raise Exception("Please supply a value for the subscription name or the management group")
    if enforcement_mode:
        enforcement_string = "true"
    else:
        enforcement_string = "false"
    template_contents = dict(
        name=name,
        policy_names=policy_names,
        subscription_name=subscription_name,
        management_group=management_group,
        enforcement_mode=enforcement_string,
        module_source=module_source
    )
    template_path = os.path.join(os.path.dirname(__file__))
    env = Environment(loader=FileSystemLoader(template_path))  # nosec
    template = env.get_template("policy-set-with-builtins.tf")
    return template.render(t=template_contents)
