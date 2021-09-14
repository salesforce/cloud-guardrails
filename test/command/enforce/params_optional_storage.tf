locals {
  name_example_PO_Enforce = "example_PO_Enforce"
  subscription_name_example_PO_Enforce = "example"
  management_group_example_PO_Enforce = ""
  category_example_PO_Enforce = "Testing"
  enforcement_mode_example_PO_Enforce = true
  policy_ids_example_PO_Enforce = [
    # -----------------------------------------------------------------------------------------------------------------
    # Storage
    # -----------------------------------------------------------------------------------------------------------------
    "1d320205-c6a1-4ac6-873d-46224024e8e2", # Azure File Sync should use private link 
    "bf045164-79ba-4215-8f95-f8048dc1780b", # Geo-redundant storage should be enabled for Storage Accounts 
    "970f84d8-71b6-4091-9979-ace7e3fb6dbb", # HPC Cache accounts should use customer-managed key for encryption 
    "21a8cd35-125e-4d13-b82d-2e19b7208bb7", # Public network access should be disabled for Azure File Sync 
    "404c3081-a854-4457-ae30-26a93ef643f9", # Secure transfer to storage accounts should be enabled 
    "b5ec538c-daa0-4006-8596-35468b9148e8", # Storage account encryption scopes should use customer-managed keys to encrypt data at rest 
    "044985bb-afe1-42cd-8a36-9d5d42424537", # Storage account keys should not be expired 
    "4fa4b6c0-31ca-4c0d-b10d-24b96f62a751", # Storage account public access should be disallowed 
    "c9d007d0-c057-4772-b18c-01e546713bcd", # Storage accounts should allow access from trusted Microsoft services 
    "37e0d2fe-28a5-43d6-a273-67d37d1f5606", # Storage accounts should be migrated to new Azure Resource Manager resources 
    "4733ea7b-a883-42fe-8cac-97454c2a9e4a", # Storage accounts should have infrastructure encryption 
    "8c6a50c6-9ffd-4ae7-986f-5fa6111f9a54", # Storage accounts should prevent shared key access 
    "34c877ad-507e-4c82-993e-3452a6e0ad3c", # Storage accounts should restrict network access 
    "2a1a9cdf-e04d-429a-8416-3bfb72a1b26f", # Storage accounts should restrict network access using virtual network rules 
    "6fac406b-40ca-413b-bf8e-0bf964659c25", # Storage accounts should use customer-managed key for encryption 
    "6edd7eda-6dd8-40f7-810d-67160c639cd9", # Storage accounts should use private link 
    
  ]
  policy_definition_map = {
    "Azure File Sync should use private link" = "/providers/Microsoft.Authorization/policyDefinitions/1d320205-c6a1-4ac6-873d-46224024e8e2",
    "Geo-redundant storage should be enabled for Storage Accounts" = "/providers/Microsoft.Authorization/policyDefinitions/bf045164-79ba-4215-8f95-f8048dc1780b",
    "HPC Cache accounts should use customer-managed key for encryption" = "/providers/Microsoft.Authorization/policyDefinitions/970f84d8-71b6-4091-9979-ace7e3fb6dbb",
    "Public network access should be disabled for Azure File Sync" = "/providers/Microsoft.Authorization/policyDefinitions/21a8cd35-125e-4d13-b82d-2e19b7208bb7",
    "Secure transfer to storage accounts should be enabled" = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9",
    "Storage account encryption scopes should use customer-managed keys to encrypt data at rest" = "/providers/Microsoft.Authorization/policyDefinitions/b5ec538c-daa0-4006-8596-35468b9148e8",
    "Storage account keys should not be expired" = "/providers/Microsoft.Authorization/policyDefinitions/044985bb-afe1-42cd-8a36-9d5d42424537",
    "Storage account public access should be disallowed" = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751",
    "Storage accounts should allow access from trusted Microsoft services" = "/providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd",
    "Storage accounts should be migrated to new Azure Resource Manager resources" = "/providers/Microsoft.Authorization/policyDefinitions/37e0d2fe-28a5-43d6-a273-67d37d1f5606",
    "Storage accounts should have infrastructure encryption" = "/providers/Microsoft.Authorization/policyDefinitions/4733ea7b-a883-42fe-8cac-97454c2a9e4a",
    "Storage accounts should prevent shared key access" = "/providers/Microsoft.Authorization/policyDefinitions/8c6a50c6-9ffd-4ae7-986f-5fa6111f9a54",
    "Storage accounts should restrict network access" = "/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c",
    "Storage accounts should restrict network access using virtual network rules" = "/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f",
    "Storage accounts should use customer-managed key for encryption" = "/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25",
    "Storage accounts should use private link" = "/providers/Microsoft.Authorization/policyDefinitions/6edd7eda-6dd8-40f7-810d-67160c639cd9",
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_PO_Enforce" {
  count = local.management_group_example_PO_Enforce != "" ? 1 : 0
  display_name  = local.management_group_example_PO_Enforce
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_PO_Enforce" {
  count                 = local.subscription_name_example_PO_Enforce != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_PO_Enforce
}

locals {
  scope = local.management_group_example_PO_Enforce != "" ? data.azurerm_management_group.example_PO_Enforce[0].id : element(data.azurerm_subscriptions.example_PO_Enforce[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_PO_Enforce_definition_lookups" {
  count = length(local.policy_ids_example_PO_Enforce)
  name  = local.policy_ids_example_PO_Enforce[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_PO_Enforce" {
  name                  = local.name_example_PO_Enforce
  policy_type           = "Custom"
  display_name          = local.name_example_PO_Enforce
  description           = local.name_example_PO_Enforce
  management_group_name = local.management_group_example_PO_Enforce == "" ? null : local.management_group_example_PO_Enforce
  metadata = tostring(jsonencode({
    category = local.category_example_PO_Enforce
  }))
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure File Sync should use private link")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Geo-redundant storage should be enabled for Storage Accounts")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "HPC Cache accounts should use customer-managed key for encryption")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Public network access should be disabled for Azure File Sync")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Secure transfer to storage accounts should be enabled")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage account encryption scopes should use customer-managed keys to encrypt data at rest")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage account keys should not be expired")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage account public access should be disallowed")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should allow access from trusted Microsoft services")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should be migrated to new Azure Resource Manager resources")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should have infrastructure encryption")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should prevent shared key access")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should restrict network access")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should restrict network access using virtual network rules")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should use customer-managed key for encryption")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should use private link")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_PO_Enforce" {
  name                 = local.name_example_PO_Enforce
  policy_definition_id = azurerm_policy_set_definition.example_PO_Enforce.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_PO_Enforce
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "example_PO_Enforce_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_PO_Enforce.id
  description = "The IDs of the Policy Assignments."
}

output "example_PO_Enforce_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_PO_Enforce_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_PO_Enforce.id
  description = "The ID of the Policy Set Definition."
}