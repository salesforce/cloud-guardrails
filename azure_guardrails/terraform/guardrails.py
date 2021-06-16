import os
from azure_guardrails.shared import utils
from azure_guardrails.terraform.terraform_no_params import TerraformTemplateNoParams
from azure_guardrails.terraform.terraform_with_params import TerraformTemplateWithParams
from azure_guardrails.iam_definition.azure_policies import AzurePolicies
from azure_guardrails.shared.parameters_categorized import CategorizedParameters
from azure_guardrails.shared.config import Config


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
        verbosity: int
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

    def generate_terraform(self, enforcement_mode: bool, category: str) -> str:
        # Generate the Terraform file content
        if self.no_params:
            policy_id_pairs = self.azure_policies.get_all_policy_ids_sorted_by_service(
                no_params=True, params_optional=self.params_optional, params_required=self.params_required,
                audit_only=self.audit_only)
            terraform_template = TerraformTemplateNoParams(
                policy_id_pairs=policy_id_pairs,
                subscription_name=self.subscription,
                management_group=self.management_group,
                enforcement_mode=enforcement_mode,
                category=category
            )
        else:
            policy_ids_sorted_by_service = self.azure_policies.get_all_policy_ids_sorted_by_service(
                no_params=self.no_params, params_optional=self.params_optional, params_required=self.params_required,
                audit_only=self.audit_only)

            categorized_parameters = CategorizedParameters(
                azure_policies=self.azure_policies,
                parameters_config=self.parameters_config,
                params_required=self.params_required,
                params_optional=self.params_optional,
                audit_only=self.audit_only
            )

            terraform_template = TerraformTemplateWithParams(
                policy_id_pairs=policy_ids_sorted_by_service,
                parameter_requirement_str=self.parameter_requirement_str,
                categorized_parameters=categorized_parameters,
                subscription_name=self.subscription,
                management_group=self.management_group,
                enforcement_mode=enforcement_mode,
                category=category
            )
        result = terraform_template.rendered()
        return result

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

    def print_success_message(self, output_file: str, enforcement_mode: bool, output_directory: str):
        utils.print_green("Success!")
        print()
        utils.print_green(f"Generated Terraform file: {os.path.relpath(output_file)}")

        if enforcement_mode:
            enforcement_message = "Enables security policies in *Enforcement mode* (illegal resource changes will be denied)"
        else:
            enforcement_message = "Enables security policies in *Audit mode* (illegal resource changes will be logged)"

        if self.service == "all":
            service_message = "Covers *all* services supported by Azure Policies."
        else:
            service_message = f"Covers *{self.service}* policies."

        if self.no_params:
            params_message = "Targets policies that do *not* require parameters"
        elif self.params_optional:
            params_message = "Targets policies where parameters are *optional* (because the parameters default values)"
        else:
            params_message = "Targets policies where parameters are *required* (because the parameters do not have default values)"

        summary_message = f"""
    The Terraform creates an Azure Policy Initiative that:
    - {enforcement_message}
    - {service_message}
    - {params_message}
    """
        print(summary_message)

        utils.print_blue("To apply these policies with Terraform:")

        if output_directory == os.getcwd():
            directory_string = ""
        else:
            directory_string = f"\n\tcd {os.path.relpath(output_directory)}"

        if self.subscription != "":
            target_string = "subscription"
        else:
            target_string = "management group"

        instructions_message = f"""
    Log in to Azure and set your subscription:
        az login
        az account set --subscription my-subscription

    Then navigate to the directory with your Terraform files and apply the policies:{directory_string}
        terraform init
        terraform plan
        terraform apply -auto-approve

    You will see that the Azure Policy Initiative is now applied to your {target_string}!
        """

        print(instructions_message)

        # TODO: Explain exemptions?
        # TODO: Give which policies are in enforcement vs not.
        # TODO: Give summary of the control categories?
