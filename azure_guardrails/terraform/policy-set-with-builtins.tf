variable "name" { default = "{{ t.name }}" }
variable "subscription_name" { default = "{{ t.subscription_name }}" }
variable "management_group" { default = "{{ t.management_group }}" }
variable "enforcement_mode" { default = {{ t.enforcement_mode }} }

module "{{ t.name }}" {
  source                         = "{{ t.module_source }}"
  description                    = var.name
  display_name                   = var.name
  subscription_name              = var.subscription_name
  management_group               = var.management_group
  enforcement_mode               = var.enforcement_mode
  policy_set_definition_category = var.name
  policy_set_name                = var.name
  policy_names = [{% for service_name, service_policy_names in t.policy_names.items() %}
    # -----------------------------------------------------------------------------------------------------------------
    # {{ service_name }}
    # -----------------------------------------------------------------------------------------------------------------{% for policy_name in service_policy_names %}
    "{{ policy_name }}",{% endfor %}
    {% endfor %}
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "policy_set_definition_ids" {
  description = "The ID of the Policy Set Definition."
  value = module.{{ t.name }}.policy_set_definition_id
}

output "policy_assignment_ids" {
  description = "The IDs of the Policy Assignments."
  value = module.{{ t.name }}.policy_set_definition_id
}

output "scope" {
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
  value = module.{{ t.name }}.scope
}

output "count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = module.{{ t.name }}.count_of_policies_applied
}