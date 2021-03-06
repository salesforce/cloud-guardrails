variable "name" { default = "{{ t.name }}" }
variable "subscription_name" { default = "{{ t.subscription_name }}" }
variable "management_group" { default = "{{ t.management_group }}" }

module "{{ t.name }}" {
  source                         = "{{ t.module_source }}"
  description                    = var.name
  display_name                   = var.name
  subscription_name              = var.subscription_name
  management_group               = var.management_group
  enforcement_mode               = {{ t.enforcement_mode }}
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
