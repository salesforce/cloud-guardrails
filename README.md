# azure-guardrails

Command-line tool that generates Azure Policies based on requirements and transforms them into Terraform.

Note: Requires Terraform 0.13.5

# Cheatsheet

## Generating Terraform

```bash
# No parameters required
azure-guardrails generate-terraform --no-params
    --service all \
    --subscription example

# With Parameters
azure-guardrails generate-terraform --params-optional
    --service all \
    --subscription example \
    --exclude-services "Guest Configuration"

# With Parameters and Empty Defaults - you will have to supply the values for these parameters
azure-guardrails generate-terraform --params-required \
    --service Kubernetes \
    --subscription example
```

## Configuration

```bash
azure-guardrails create-config-file
```

## Other commands

```bash
# List all the existing built-in Azure Policies
azure-guardrails list-policies

# List all the services supported by Azure built-in Policies
azure-guardrails list-services
```

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
azure-guardrails generate-terraform --no-params
    --service all \
    --subscription example
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
azure-guardrails generate-terraform --no-params \
    --service "Key Vault"
    --subscription example
```

* Output:

```hcl
locals {
  name_example_noparams = "example_noparams"
  subscription_name_example_noparams = "example"
  management_group_example_noparams = ""
  enforcement_mode_example_noparams = false
  policy_names_example_noparams = [
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Key Vault Managed HSM should have purge protection enabled",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "[Preview]: Firewall should be enabled on Key Vault",
    "[Preview]: Key Vault keys should have an expiration date",
    "[Preview]: Key Vault secrets should have an expiration date",
    "[Preview]: Keys should be backed by a hardware security module (HSM)",
    "[Preview]: Private endpoint should be configured for Key Vault",
    "[Preview]: Secrets should have content type set",

  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "example_noparams" {
  count        = length(local.policy_names_example_noparams)
  display_name = element(local.policy_names_example_noparams, count.index)
}

locals {
  example_noparams_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.example_noparams.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_noparams" {
  count = local.management_group_example_noparams != "" ? 1 : 0
  display_name  = local.management_group_example_noparams
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_noparams" {
  count                 = local.subscription_name_example_noparams != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_noparams
}

locals {
  example_noparams_scope = local.management_group_example_noparams != "" ? data.azurerm_management_group.example_noparams[0].id : element(data.azurerm_subscriptions.example_noparams[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "example_noparams" {
  name                  = local.name_example_noparams
  policy_type           = "Custom"
  display_name          = local.name_example_noparams
  description           = local.name_example_noparams
  management_group_name = local.management_group_example_noparams == "" ? null : local.management_group_example_noparams
  policy_definitions    = tostring(jsonencode(local.example_noparams_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_example_noparams
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_noparams" {
  name                 = local.name_example_noparams
  policy_definition_id = azurerm_policy_set_definition.example_noparams.id
  scope                = local.example_noparams_scope
  enforcement_mode     = local.enforcement_mode_example_noparams
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_noparams.*.id
  description = "The IDs of the Policy Assignments."
}

output "scope" {
  value       = local.example_noparams_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_noparams.id
  description = "The ID of the Policy Set Definition."
}

output "count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_names_example_noparams)
}
```

# References

* [Azure Policy Definition Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
* [Azure Policy Assignment Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)
* [Authorization Schemas](https://github.com/Azure/azure-resource-manager-schemas/search?q=schemas+in%3Apath+filename%3AMicrosoft.Authorization.json)
