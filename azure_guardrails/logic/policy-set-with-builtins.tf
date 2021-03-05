locals { name = "{{ t.name }}" }

module "name" {
  source                         = "{{ t.module_source }}"
  description                    = local.name
  display_name                   = local.name
  subscription_name              = "{{ t.subscription_name }}"
  management_group               = "{{ t.management_group }}"
  enforcement_mode               = {{ t.enforcement_mode }}
  policy_set_definition_category = local.name
  policy_set_name                = local.name
  policy_names = [{% for policy_name in t.policy_names %}
    "{{ policy_name }}",{% endfor %}
  ]
}
