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

output "count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(var.policy_names)
}