resource "azurerm_policy_set_definition" "guardrails" {
  name                  = var.policy_set_name
  policy_type           = "Custom"
  display_name          = var.display_name
  description           = var.description
  management_group_name = var.management_group == "" ? null : var.management_group
  policy_definitions    = tostring(jsonencode(local.policy_definitions))
  metadata = tostring(jsonencode({
    category = var.policy_set_definition_category
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "guardrails" {
  name                 = var.policy_set_name
  policy_definition_id = azurerm_policy_set_definition.guardrails.id
  scope                = local.scope
  enforcement_mode     = var.enforcement_mode
}
