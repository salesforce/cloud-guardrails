# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "definitions" {
  count        = length(var.policy_names)
  display_name = element(var.policy_names, count.index)
}

locals {
  policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.definitions.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example" {
  count = var.management_group != "" ? 1 : 0
  name  = var.management_group
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example" {
  count                 = var.subscription_name != "" ? 1 : 0
  display_name_contains = var.subscription_name
}

locals {
  scope = var.management_group != "" ? data.azurerm_management_group.example[0].id : element(data.azurerm_subscriptions.example[0].subscriptions.*.id, 0)
}
