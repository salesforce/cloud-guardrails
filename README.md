# azure-guardrails

Command-line tool that generates Azure Policies based on requirements and transforms them into Terraform.

# Instructions

## Installation

```bash
# Install
make install
```

## Generate Terraform

### Short explanation

* First, log into Azure and set your subscription

```bash
# Run the Terraform demo
# First, log into Azure
az login
az account set --subscription my-subscription
```

* Then generate the Terraform files:

```bash
# TODO: This is temporary. We will just reference the default remote repository once this is public
export TERRAFORM_MODULE_SOURCE="../../azure_guardrails/shared/terraform/policy-initiative-with-builtins"

export TARGET_NAME="mysubscription" # TODO: Change this to your subscription name
export TARGET_TYPE="subscription" # TODO: You can also set this to 'mg' to apply it to a management group

azure-guardrails generate-terraform \
    --module-source ${TERRAFORM_MODULE_SOURCE} \
    --service all \
    --policy-set-name example \
    --target-type ${TARGET_TYPE} \
    --target-name ${TARGET_NAME} \
    --quiet > examples/terraform-demo/main.tf
```

* Navigate to the Terraform directory and apply the policies:

```bash
cd examples/terraform-demo/
terraform init
terraform plan
terraform apply -auto-approve
```

### Full example

```bash
azure-guardrails generate-terraform --service "Key Vault" --quiet
```

* Output:

```hcl
variable "name" { default = "example" }

module "name" {
  source                         = "git@github.com:kmcquade/azure-guardrails.git//azure_guardrails/shared/terraform/policy-initiative-with-builtins"
  description                    = var.name
  display_name                   = var.name
  subscription_name              = "example-subscription"
  management_group               = ""
  enforcement_mode               = false
  policy_set_definition_category = var.name
  policy_set_name                = var.name
  policy_names = [
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------

    "Azure Key Vault Managed HSM should have purge protection enabled",
    "Firewall should be enabled on Key Vault",
    "Key Vault keys should have an expiration date",
    "Key Vault secrets should have an expiration date",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "Keys should be backed by a hardware security module (HSM)",
    "Private endpoint should be configured for Key Vault",
    "Secrets should have content type set",
  ]
}
```

# TODO

Tweaks:
* Add ability to use policies with parameters as long as they have default values
* Config: Should be able to specify explicit match strings in the command line

Enhancement:
* Add ability to supply the values that you want to put in the policy?

# References

* [Azure Policy Definition Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
* [Authorization Schemas](https://github.com/Azure/azure-resource-manager-schemas/search?q=schemas+in%3Apath+filename%3AMicrosoft.Authorization.json)
* [Pydantic Datamodel code generator](https://pydantic-docs.helpmanual.io/datamodel_code_generator/)
