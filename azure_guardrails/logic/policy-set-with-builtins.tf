variable "name" { default = "{{ t.name }}" }

module "{{ t.name }}" {
  source                         = "{{ t.module_source }}"
  description                    = var.name
  display_name                   = var.name
  subscription_name              = "{{ t.subscription_name }}"
  management_group               = "{{ t.management_group }}"
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
