locals {
  name_{{ t.label }} = "{{ t.initiative_name }}"
  subscription_name_{{ t.label }} = "{{ t.subscription_name }}"
  management_group_{{ t.label }} = "{{ t.management_group }}"
  enforcement_mode_{{ t.label }} = {{ t.enforcement_mode }}
  policy_ids_{{ t.label }} = [{% for service_name, service_policies in t.policy_id_pairs.items() %}
    # -----------------------------------------------------------------------------------------------------------------
    # {{ service_name }}
    # -----------------------------------------------------------------------------------------------------------------{% for policy_id, policy_details in service_policies.items() %}
    "{{ policy_details.short_id }}", # {{ policy_details.display_name }} {% endfor %}
    {% endfor %}
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "{{ t.label }}" {
  count        = length(local.policy_ids_{{ t.label }})
  name         = element(local.policy_ids_{{ t.label }}, count.index)
}

locals {
  {{ t.label }}_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.{{ t.label }}.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "{{ t.label }}" {
  count = local.management_group_{{ t.label }} != "" ? 1 : 0
  display_name  = local.management_group_{{ t.label }}
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "{{ t.label }}" {
  count                 = local.subscription_name_{{ t.label }} != "" ? 1 : 0
  display_name_contains = local.subscription_name_{{ t.label }}
}

locals {
  {{ t.label }}_scope = local.management_group_{{ t.label }} != "" ? data.azurerm_management_group.{{ t.label }}[0].id : element(data.azurerm_subscriptions.{{ t.label }}[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "{{ t.label }}" {
  name                  = local.name_{{ t.label }}
  policy_type           = "Custom"
  display_name          = local.name_{{ t.label }}
  description           = local.name_{{ t.label }}
  management_group_name = local.management_group_{{ t.label }} == "" ? null : local.management_group_{{ t.label }}
  policy_definitions    = tostring(jsonencode(local.{{ t.label }}_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_{{ t.label }}
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "{{ t.label }}" {
  name                 = local.name_{{ t.label }}
  policy_definition_id = azurerm_policy_set_definition.{{ t.label }}.id
  scope                = local.{{ t.label }}_scope
  enforcement_mode     = local.enforcement_mode_{{ t.label }}
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "{{ t.label }}_policy_assignment_ids" {
  value       = azurerm_policy_assignment.{{ t.label }}.id
  description = "The IDs of the Policy Assignments."
}

output "{{ t.label }}_scope" {
  value       = local.{{ t.label }}_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "{{ t.label }}_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.{{ t.label }}.id
  description = "The ID of the Policy Set Definition."
}

output "{{ t.label }}_count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_ids_{{ t.label }})
}