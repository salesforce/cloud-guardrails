locals {
  name_example_PR_Audit = "example_PR_Audit"
  subscription_name_example_PR_Audit = "example"
  management_group_example_PR_Audit = ""
  category_example_PR_Audit = "Testing"
  enforcement_mode_example_PR_Audit = false
  policy_ids_example_PR_Audit = [
    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "26ee67a2-f81a-4ba8-b9ce-8550bd5ee1a7", # Metric alert rules should be configured on Batch accounts

  ]
  policy_definition_map = {
    "Metric alert rules should be configured on Batch accounts" = "/providers/Microsoft.Authorization/policyDefinitions/26ee67a2-f81a-4ba8-b9ce-8550bd5ee1a7",
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_PR_Audit" {
  count = local.management_group_example_PR_Audit != "" ? 1 : 0
  display_name  = local.management_group_example_PR_Audit
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_PR_Audit" {
  count                 = local.subscription_name_example_PR_Audit != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_PR_Audit
}

locals {
  scope = local.management_group_example_PR_Audit != "" ? data.azurerm_management_group.example_PR_Audit[0].id : element(data.azurerm_subscriptions.example_PR_Audit[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_PR_Audit_definition_lookups" {
  count = length(local.policy_ids_example_PR_Audit)
  name  = local.policy_ids_example_PR_Audit[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_PR_Audit" {
  name                  = local.name_example_PR_Audit
  policy_type           = "Custom"
  display_name          = local.name_example_PR_Audit
  description           = local.name_example_PR_Audit
  management_group_name = local.management_group_example_PR_Audit == "" ? null : local.management_group_example_PR_Audit
  metadata = tostring(jsonencode({
    category = local.category_example_PR_Audit
  }))
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Metric alert rules should be configured on Batch accounts")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        metricName = { "value" : "example" }
    })
    reference_id = null
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_PR_Audit" {
  name                 = local.name_example_PR_Audit
  policy_definition_id = azurerm_policy_set_definition.example_PR_Audit.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_PR_Audit
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "example_PR_Audit_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_PR_Audit.id
  description = "The IDs of the Policy Assignments."
}

output "example_PR_Audit_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_PR_Audit_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_PR_Audit.id
  description = "The ID of the Policy Set Definition."
}
