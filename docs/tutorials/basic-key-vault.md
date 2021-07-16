## Basic Tutorial: Key Vault Example

You can also generate policies for a single service. Consider the example below where we generate Terraform for Key Vault only:

```bash
cloud-guardrails generate-terraform --no-params \
    --service "Key Vault" \
    --subscription example
```

<details>
<summary>Click to expand!</summary>
<p>

```hcl
locals {
  name_no_params = "example_NP_Audit"
  subscription_name_no_params = "example"
  management_group_no_params = ""
  enforcement_mode_no_params = false
  policy_ids_no_params = [
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "c39ba22d-4428-4149-b981-70acb31fc383", # Azure Key Vault Managed HSM should have purge protection enabled
    "0b60c0b2-2dc2-4e1c-b5c9-abbed971de53", # Key vaults should have purge protection enabled
    "1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d", # Key vaults should have soft delete enabled
    "55615ac9-af46-4a59-874e-391cc3dfb490", # Firewall should be enabled on Key Vault
    "152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0", # Key Vault keys should have an expiration date
    "98728c90-32c7-4049-8429-847dc0f4fe37", # Key Vault secrets should have an expiration date
    "587c79fe-dd04-4a5e-9d0b-f89598c7261b", # Keys should be backed by a hardware security module (HSM)
    "5f0bc445-3935-4915-9981-011aa2b46147", # Private endpoint should be configured for Key Vault
    "75262d3e-ba4a-4f43-85f8-9f72c090e5e3", # Secrets should have content type set

  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "no_params" {
  count        = length(local.policy_ids_no_params)
  name         = element(local.policy_ids_no_params, count.index)
}

locals {
  no_params_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.no_params.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "no_params" {
  count = local.management_group_no_params != "" ? 1 : 0
  display_name  = local.management_group_no_params
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "no_params" {
  count                 = local.subscription_name_no_params != "" ? 1 : 0
  display_name_contains = local.subscription_name_no_params
}

locals {
  no_params_scope = local.management_group_no_params != "" ? data.azurerm_management_group.no_params[0].id : element(data.azurerm_subscriptions.no_params[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "no_params" {
  name                  = local.name_no_params
  policy_type           = "Custom"
  display_name          = local.name_no_params
  description           = local.name_no_params
  management_group_name = local.management_group_no_params == "" ? null : local.management_group_no_params
  policy_definitions    = tostring(jsonencode(local.no_params_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_no_params
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "no_params" {
  name                 = local.name_no_params
  policy_definition_id = azurerm_policy_set_definition.no_params.id
  scope                = local.no_params_scope
  enforcement_mode     = local.enforcement_mode_no_params
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "no_params_policy_assignment_ids" {
  value       = azurerm_policy_assignment.no_params.id
  description = "The IDs of the Policy Assignments."
}

output "no_params_scope" {
  value       = local.no_params_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "no_params_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.no_params.id
  description = "The ID of the Policy Set Definition."
}

output "no_params_count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_ids_no_params)
}
```
</details>
