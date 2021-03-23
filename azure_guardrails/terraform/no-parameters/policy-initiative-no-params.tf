locals {
  name_{{ t.name }} = "{{ t.initiative_name }}"
  subscription_name_{{ t.name }} = "{{ t.subscription_name }}"
  management_group_{{ t.name }} = "{{ t.management_group }}"
  enforcement_mode_{{ t.name }} = {{ t.enforcement_mode }}
  policy_ids_{{ t.name }} = [{% for service_name, service_policies in t.policy_id_pairs.items() %}
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
data "azurerm_policy_definition" "{{ t.name }}" {
  count        = length(local.policy_ids_{{ t.name }})
  name         = element(local.policy_ids_{{ t.name }}, count.index)
}

locals {
  {{ t.name }}_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.{{ t.name }}.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "{{ t.name }}" {
  count = local.management_group_{{ t.name }} != "" ? 1 : 0
  display_name  = local.management_group_{{ t.name }}
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "{{ t.name }}" {
  count                 = local.subscription_name_{{ t.name }} != "" ? 1 : 0
  display_name_contains = local.subscription_name_{{ t.name }}
}

locals {
  {{ t.name }}_scope = local.management_group_{{ t.name }} != "" ? data.azurerm_management_group.{{ t.name }}[0].id : element(data.azurerm_subscriptions.{{ t.name }}[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "{{ t.name }}" {
  name                  = local.name_{{ t.name }}
  policy_type           = "Custom"
  display_name          = local.name_{{ t.name }}
  description           = local.name_{{ t.name }}
  management_group_name = local.management_group_{{ t.name }} == "" ? null : local.management_group_{{ t.name }}
  policy_definitions    = tostring(jsonencode(local.{{ t.name }}_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_{{ t.name }}
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "{{ t.name }}" {
  name                 = local.name_{{ t.name }}
  policy_definition_id = azurerm_policy_set_definition.{{ t.name }}.id
  scope                = local.{{ t.name }}_scope
  enforcement_mode     = local.enforcement_mode_{{ t.name }}
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "{{ t.name }}_policy_assignment_ids" {
  value       = azurerm_policy_assignment.{{ t.name }}.id
  description = "The IDs of the Policy Assignments."
}

output "{{ t.name }}_scope" {
  value       = local.{{ t.name }}_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "{{ t.name }}_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.{{ t.name }}.id
  description = "The ID of the Policy Set Definition."
}

output "{{ t.name }}_count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_ids_{{ t.name }})
}