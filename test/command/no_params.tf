locals {
  name_no_params = "example_NP_Enforce"
  subscription_name_no_params = "example"
  management_group_no_params = ""
  enforcement_mode_no_params = true
  policy_ids_no_params = [
    # -----------------------------------------------------------------------------------------------------------------
    # Compute
    # -----------------------------------------------------------------------------------------------------------------
    "06a78e20-9358-41c9-923c-fb736d382a4d", # Audit VMs that do not use managed disks 
    "0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56", # Audit virtual machines without disaster recovery configured 
    "465f0161-0087-490a-9ad9-ad6217f4f43a", # Require automatic OS image patching on Virtual Machine Scale Sets 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Data Lake
    # -----------------------------------------------------------------------------------------------------------------
    "a7ff3161-0087-490a-9ad9-ad6217f4f43a", # Require encryption on Data Lake Store accounts 
    
    # -----------------------------------------------------------------------------------------------------------------
    # General
    # -----------------------------------------------------------------------------------------------------------------
    "0a914e76-4921-4c19-b460-a2d36003525a", # Audit resource location matches resource group location 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "35f9c03a-cc27-418e-9c0c-539ff999d010", # Gateway subnets should not be configured with a network security group 
    "88c0b9da-ce96-4b03-9635-f29a937e2900", # Network interfaces should disable IP forwarding 
    "83a86a26-fd1f-447c-b59d-e51f44264114", # Network interfaces should not have public IPs 
    
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "no_params" {
  count        = length(local.policy_ids_no_params)
  name         = element(local.policy_ids_no_params, count.index)
}

locals {
  no_params_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.no_params.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "no_params" {
  count = local.management_group_no_params != "" ? 1 : 0
  display_name  = local.management_group_no_params
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "no_params" {
  count                 = local.subscription_name_no_params != "" ? 1 : 0
  display_name_contains = local.subscription_name_no_params
}

locals {
  no_params_scope = local.management_group_no_params != "" ? data.azurerm_management_group.no_params[0].id : element(data.azurerm_subscriptions.no_params[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "no_params" {
  name                  = local.name_no_params
  policy_type           = "Custom"
  display_name          = local.name_no_params
  description           = local.name_no_params
  management_group_name = local.management_group_no_params == "" ? null : local.management_group_no_params
  policy_definitions    = tostring(jsonencode(local.no_params_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_no_params
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "no_params" {
  name                 = local.name_no_params
  policy_definition_id = azurerm_policy_set_definition.no_params.id
  scope                = local.no_params_scope
  enforcement_mode     = local.enforcement_mode_no_params
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "no_params_policy_assignment_ids" {
  value       = azurerm_policy_assignment.no_params.id
  description = "The IDs of the Policy Assignments."
}

output "no_params_scope" {
  value       = local.no_params_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "no_params_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.no_params.id
  description = "The ID of the Policy Set Definition."
}

output "no_params_count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_ids_no_params)
}