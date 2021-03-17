locals {
  name_{{ t.name }} = "{{ t.name }}"
  subscription_name_{{ t.name }} = "{{ t.subscription_name }}"
  management_group_{{ t.name }} = "{{ t.management_group }}"
  category_{{ t.name }} = "{{ t.category }}"
  enforcement_mode_{{ t.name }} = {{ t.enforcement_mode }}
  policy_names = [{% for service_name, policies_with_params in t.policies_sorted_by_service.items() %}
    # -----------------------------------------------------------------------------------------------------------------
    # {{ service_name }}
    # -----------------------------------------------------------------------------------------------------------------{% for key in policies_with_params %}
    "{{ key }}",{% endfor %}{% endfor %}
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.{{ t.name }}_definition_lookups.*.display_name,
    data.azurerm_policy_definition.{{ t.name }}_definition_lookups.*.id
  )
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
  scope = local.management_group_{{ t.name }} != "" ? data.azurerm_management_group.{{ t.name }}[0].id : element(data.azurerm_subscriptions.{{ t.name }}[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "{{ t.name }}_definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "{{ t.name }}" {
  name                  = local.name_{{ t.name }}
  policy_type           = "Custom"
  display_name          = local.name_{{ t.name }}
  description           = local.name_{{ t.name }}
  management_group_name = local.management_group_{{ t.name }} == "" ? null : local.management_group_{{ t.name }}
  metadata = tostring(jsonencode({
    category = local.category_{{ t.name }}
  }))

  {% for service_name, service_policy_details in t.policy_definition_reference_parameters.items() %}
  {% for policy_definition_name, policy_definition_params in service_policy_details.items() %}
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "{{ policy_definition_name }}")
    parameter_values = jsonencode({ {% for key, value in policy_definition_params.items() %}
      {{ value.name }} = { "value" : "{{ value.policy_definition_reference_value }}" }{% endfor %}
    })
    reference_id = null
  }
  {% endfor %}{% endfor %}

  parameters = <<PARAMETERS
{{ t.initiative_parameters }}
PARAMETERS
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "{{ t.name }}" {
  name                 = local.name_{{ t.name }}
  policy_definition_id = azurerm_policy_set_definition.{{ t.name }}.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_{{ t.name }}
  parameters = jsonencode({
    {{ t.policy_assignment_parameters }}
})
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "{{ t.name }}_policy_assignment_ids" {
  value       = azurerm_policy_assignment.{{ t.name }}.id
  description = "The IDs of the Policy Assignments."
}

output "{{ t.name }}_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "{{ t.name }}_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.{{ t.name }}.id
  description = "The ID of the Policy Set Definition."
}
