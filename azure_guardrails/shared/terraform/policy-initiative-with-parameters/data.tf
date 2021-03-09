data "azurerm_policy_definition" "allowed_host_paths" {
  display_name = "Kubernetes cluster pod hostPath volumes should only use allowed host paths"
}

variable "category" {}
variable "name" {}
variable "management_group" {}

resource "azurerm_policy_set_definition" "guardrails" {
  name                  = var.name
  policy_type           = "Custom"
  display_name          = var.name
  description           = var.name
  management_group_name = var.management_group == "" ? null : var.management_group
//  parameters = local.parameters
  parameters = data.azurerm_policy_definition.allowed_host_paths.parameters
  policy_definition_reference    = tostring(jsonencode(local.policy_definitions))
  metadata = tostring(jsonencode({
    category = var.category
  }))
}


locals {
    parameters  = <<PARAMETERS
  {
        "category": "Tenant Level Policy"
  }
  PARAMETERS
}