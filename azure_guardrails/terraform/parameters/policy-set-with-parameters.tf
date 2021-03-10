variable "name" { default = "{{ t.name }}" }
variable "subscription_name" { default = "{{ t.subscription_name }}" }
variable "management_group" { default = "{{ t.management_group }}" }
variable "enforcement_mode" { default = {{ t.enforcement_mode }} }

variable "category" {
  type    = string
  default = "Testing"
}
provider "azurerm" {
  features {}
}

locals {
  policy_names = [{% for service_name, policies_with_params in t.sorted_policies.items() %}
    # -----------------------------------------------------------------------------------------------------------------
    # {{ service_name }}
    # -----------------------------------------------------------------------------------------------------------------{% for key, value in policies_with_params.items() %}
    "{{ key }}",{% endfor %}{% endfor %}
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.definition_lookups.*.display_name,
    data.azurerm_policy_definition.definition_lookups.*.id
  )
}

data "azurerm_policy_definition" "definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

resource "azurerm_policy_set_definition" "guardrails" {
  name                  = var.name
  policy_type           = "Custom"
  display_name          = var.name
  description           = var.name
  management_group_name = var.management_group == "" ? null : var.management_group
  metadata = tostring(jsonencode({
    category = var.category
  }))

  {% for service_name, policies_with_params in t.policy_definition_reference_parameters.items() %}
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "{{ service_name }}")
    parameter_values = jsonencode({ {% for key in policies_with_params %}
      {{ key }} = { "value" : "[parameters('{{ key }}')]" }{% endfor %}
    })
    reference_id = null
  }
  {% endfor %}

  parameters = <<PARAMETERS
{{ t.all_parameters }}
PARAMETERS
}

output "id" {
  value = azurerm_policy_set_definition.guardrails.id
}