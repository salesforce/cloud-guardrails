# Copyright (c) 2021, salesforce.com, inc.
# All rights reserved.
# Licensed under the BSD 3-Clause license.
# For full license text, see the LICENSE file in the repo root
# or https://opensource.org/licenses/BSD-3-Clause
import os
import logging
from colorama import Fore
from jinja2 import Environment, FileSystemLoader
from cloud_guardrails.shared import utils
from cloud_guardrails.terraform.terraform_no_params import TerraformTemplateNoParams
from cloud_guardrails.terraform.terraform_with_params import TerraformTemplateWithParams
from cloud_guardrails.iam_definition.azure_policies import AzurePolicies
from cloud_guardrails.shared.parameters_categorized import CategorizedParameters
from cloud_guardrails.shared.config import Config
logger = logging.getLogger(__name__)


class TerraformGuardrails:
    def __init__(
        self,
        service: str,
        config: Config,
        subscription: str,
        management_group: str,
        parameters_config: dict,
        no_params: bool,
        params_optional: bool,
        params_required: bool,
        enforcement_mode: bool,
        verbosity: int,
        category: str = "Testing"
    ):
        self.service = service
        self.config = config
        self.azure_policies = self.set_iam_definition()

        if subscription:
            self.subscription = subscription
            self.management_group = ""
        else:
            self.subscription = ""
            self.management_group = management_group

        self.parameters_config = parameters_config
        self.no_params = no_params
        self.params_optional = params_optional
        self.params_required = params_required

        self.audit_only = False
        self.enforcement_mode = enforcement_mode

        self.category = category
        self.verbosity = verbosity

    def set_iam_definition(self) -> AzurePolicies:
        # Initialize the IAM Definition
        if self.service == "all":
            azure_policies = AzurePolicies(service_names=["all"], config=self.config)
        else:
            azure_policies = AzurePolicies(service_names=[self.service], config=self.config)
        return azure_policies

    @property
    def parameter_requirement_str(self) -> str:
        if self.no_params:
            return "NP"
        elif self.params_optional:
            return "PO"
        elif self.params_required:
            return "PR"

    @property
    def file_name(self) -> str:
        """A file name based on parameter requirements and service name"""
        if self.service == "all":
            service_string = ""
        else:
            service_string = f"_{self.service.lower().strip()}"

        if self.no_params:
            return f"no_params{service_string}.tf"
        elif self.params_optional:
            return f"params_optional{service_string}.tf"
        elif self.params_required:
            return f"params_required{service_string}.tf"

    def policy_id_pairs(self) -> dict:
        if self.no_params:
            policy_ids_sorted_by_service = self.azure_policies.get_all_policy_ids_sorted_by_service(
                no_params=True, params_optional=self.params_optional, params_required=self.params_required,
                audit_only=self.audit_only)
        else:
            policy_ids_sorted_by_service = self.azure_policies.get_all_policy_ids_sorted_by_service(
                no_params=self.no_params, params_optional=self.params_optional, params_required=self.params_required,
                audit_only=self.audit_only)
        return policy_ids_sorted_by_service

    def policy_names(self) -> list:
        policy_id_pairs = self.policy_id_pairs()
        policies = []
        for service_name, service_policies in policy_id_pairs.items():
            for service_policy_name, service_policy_content in service_policies.items():
                policies.append(service_policy_name)
        return policies

    def policy_ids(self) -> list:
        policy_id_pairs = self.policy_id_pairs()
        policies = []
        for service_name, service_policies in policy_id_pairs.items():
            for service_policy_name, service_policy_content in service_policies.items():
                policies.append(service_policy_content.get("display_name"))
        return policies

    def generate_terraform(self) -> str:
        # Generate the Terraform file content
        if self.no_params:
            terraform_template = TerraformTemplateNoParams(
                policy_id_pairs=self.policy_id_pairs(),
                subscription_name=self.subscription,
                management_group=self.management_group,
                enforcement_mode=self.enforcement_mode,
                category=self.category
            )
        else:
            categorized_parameters = CategorizedParameters(
                azure_policies=self.azure_policies,
                parameters_config=self.parameters_config,
                params_required=self.params_required,
                params_optional=self.params_optional,
                audit_only=self.audit_only
            )

            terraform_template = TerraformTemplateWithParams(
                policy_id_pairs=self.policy_id_pairs(),
                parameter_requirement_str=self.parameter_requirement_str,
                categorized_parameters=categorized_parameters,
                subscription_name=self.subscription,
                management_group=self.management_group,
                enforcement_mode=self.enforcement_mode,
                category=self.category
            )
        result = terraform_template.rendered()
        return result

    def create_terraform_file(self, output_file: str):
        terraform_content = self.generate_terraform()
        if os.path.exists(output_file):
            logger.info("%s exists. Removing the file and replacing its contents." % output_file)
            os.remove(output_file)
        with open(output_file, "w") as f:
            f.write(terraform_content)

    def create_terraform_provider_file(self, output_file: str):
        template_contents = dict(
            provider_version="=2.56.0"
        )
        template_path = os.path.join(os.path.dirname(__file__), "provider")
        env = Environment(loader=FileSystemLoader(template_path))  # nosec
        template = env.get_template("provider.tf.j2")
        rendered_template = template.render(t=template_contents)
        if os.path.exists(output_file):
            logger.info("%s exists. Removing the file and replacing its contents." % output_file)
            os.remove(output_file)
        with open(output_file, "w") as f:
            f.write(rendered_template)

    def create_markdown_summary_file(self, directory: str = None):
        # Write Markdown summary
        markdown_table = self.azure_policies.markdown_table(
            no_params=self.no_params, params_optional=self.params_optional, params_required=self.params_required
        )
        markdown_file = f"{self.parameter_requirement_str}-{self.service}-table.md"
        if directory:
            markdown_file = os.path.join(directory, markdown_file)
        if os.path.exists(markdown_file):
            if self.verbosity >= 1:
                utils.print_grey(f"Removing the previous file: {markdown_file}")
            os.remove(markdown_file)
        with open(markdown_file, "w") as f:
            f.write(markdown_table)

    def create_csv_summary_file(self, directory: str = None):
        # Write CSV summary
        csv_file = f"{self.parameter_requirement_str}-{self.service}-table.csv"
        if directory:
            csv_file = os.path.join(directory, csv_file)
        self.azure_policies.csv_summary(
            csv_file,
            verbosity=self.verbosity,
            no_params=self.no_params,
            params_optional=self.params_optional,
            params_required=self.params_required
        )

    def green_policy_count(self) -> str:
        return f"{Fore.GREEN}{len(self.policy_names())}{utils.END}"

    def print_success_message(self, output_file: str, enforcement_mode: bool, output_directory: str):
        utils.print_green("Success!")
        print()
        utils.print_green(f"Generated Terraform file: {os.path.relpath(output_file)}")

        if enforcement_mode:
            enforcement_message = f"Enables {self.green_policy_count()} security policies in {Fore.GREEN}Enforcement mode{utils.END} (illegal resource " \
                                  f"\n      changes will be denied)"
        else:
            enforcement_message = f"Enables {self.green_policy_count()} security policies in {Fore.GREEN}Audit mode{utils.END} (illegal resource " \
                                  f"\n      changes will be logged)"

        if self.service == "all":
            service_message = f"Covers {Fore.GREEN}all{utils.END} services supported by Azure Policies."
        else:
            service_message = f"Covers {Fore.GREEN}{self.service}{utils.END} policies."

        if self.no_params:
            params_message = f"Targets {self.green_policy_count()} policies that do {Fore.GREEN}not{utils.END} require parameters"
        elif self.params_optional:
            params_message = f"Targets {self.green_policy_count()} policies where parameters are {Fore.GREEN}optional{utils.END} (because the parameters default values)"
        else:
            params_message = f"Targets {self.green_policy_count()} policies where parameters are {Fore.GREEN}required{utils.END} (because the parameters do not have default values)"

        summary_message = f"""
    The Terraform creates an Azure Policy Initiative that:
    - {enforcement_message}
    - {service_message}
    - {params_message}
    """
        print(summary_message)

        utils.print_blue("To apply these policies with Terraform:")

        if output_directory == os.getcwd():
            directory_string = "\r"
        else:
            directory_string = f"Navigate to the directory with your Terraform files.\n\t\tcd {os.path.relpath(output_directory)}"

        if self.subscription != "":
            target_string = "subscription"
        else:
            target_string = "management group"

        instructions_message = f"""
    Log in to Azure and set your subscription:
        az login
        az account set --subscription my-subscription

    {directory_string}

    Now apply the policies:
        terraform init
        terraform plan
        terraform apply -auto-approve

    You will see that the Azure Policy Initiative is now applied to
    your {target_string}!
        """

        print(instructions_message)

        # TODO: Explain exemptions?
        # TODO: Give summary of the control categories?
