output "policy_assignment_ids" {
  value       = azurerm_policy_assignment.guardrails.*.id
  description = "The IDs of the Policy Assignments."
}

output "scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "policy_set_definition_id" {
  value       = azurerm_policy_set_definition.guardrails.id
  description = "The ID of the Policy Set Definition."
}
