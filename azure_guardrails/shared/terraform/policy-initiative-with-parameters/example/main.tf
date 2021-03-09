variable "name" { default = "example" }
variable "subscription_name" { default = "" }
variable "management_group" { default = "" }
variable "enforcement_mode" { default = false }

variable "category" {
  type    = string
  default = "Testing"
}
provider "azurerm" {
  features {}
}

locals {
  policy_names = [
    "Do not allow privileged containers in Kubernetes cluster",
    "Enforce internal load balancers in Kubernetes cluster"
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.definition_lookups.*.display_name,
    data.azurerm_policy_definition.definition_lookups.*.id
  )
}

data "azurerm_policy_definition" "definition_lookups" {
  count = length(local.policy_names)
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
  parameters = <<PARAMETERS
{
"excludedNamespaces": {
        "type": "Array",
        "metadata": {
          "displayName": "Namespace exclusions",
          "description": "List of Kubernetes namespaces to exclude from policy evaluation."
        },
        "defaultValue": ["kube-system", "gatekeeper-system", "azure-arc"]
      },
      "namespaces": {
        "type": "Array",
        "metadata": {
          "displayName": "Namespace inclusions",
          "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces."
        },
        "defaultValue": []
      }
}
PARAMETERS
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Do not allow privileged containers in Kubernetes cluster")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces         = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

}
