variable "name" { default = "example-params" }
variable "subscription_name" { default = "example" }
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
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Azure Key Vault Managed HSM should be enabled",
    "Resource logs in Key Vault should be enabled",
    "[Preview]: Certificates should be issued by the specified integrated certificate authority",
    "[Preview]: Certificates should have the specified maximum validity period",
    "[Preview]: Certificates should use allowed key types",
    "[Preview]: Certificates using elliptic curve cryptography should have allowed curve names",
    "[Preview]: Keys should be the specified cryptographic type RSA or EC",
    "[Preview]: Keys using elliptic curve cryptography should have the specified curve names",
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.example-params_definition_lookups.*.display_name,
    data.azurerm_policy_definition.example-params_definition_lookups.*.id
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example-params" {
  count = var.management_group != "" ? 1 : 0
  name  = var.management_group
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example-params" {
  count                 = var.subscription_name != "" ? 1 : 0
  display_name_contains = var.subscription_name
}

locals {
  scope = var.management_group != "" ? data.azurerm_management_group.example-params[0].id : element(data.azurerm_subscriptions.example-params[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example-params_definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example-params_guardrails" {
  name                  = var.name
  policy_type           = "Custom"
  display_name          = var.name
  description           = var.name
  management_group_name = var.management_group == "" ? null : var.management_group
  metadata = tostring(jsonencode({
    category = var.category
  }))

  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Azure Key Vault Managed HSM should be enabled")
    parameter_values = jsonencode({ 
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Key Vault should be enabled")
    parameter_values = jsonencode({ 
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should be issued by the specified integrated certificate authority")
    parameter_values = jsonencode({ 
      allowedCAs = { "value" : "[parameters('allowedCAs')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should have the specified maximum validity period")
    parameter_values = jsonencode({ 
      maximumValidityInMonths = { "value" : "[parameters('maximumValidityInMonths')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should use allowed key types")
    parameter_values = jsonencode({ 
      allowedKeyTypes = { "value" : "[parameters('allowedKeyTypes')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates using elliptic curve cryptography should have allowed curve names")
    parameter_values = jsonencode({ 
      allowedECNames = { "value" : "[parameters('allowedECNames')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should be the specified cryptographic type RSA or EC")
    parameter_values = jsonencode({ 
      allowedKeyTypes = { "value" : "[parameters('allowedKeyTypes')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys using elliptic curve cryptography should have the specified curve names")
    parameter_values = jsonencode({ 
      allowedECNames = { "value" : "[parameters('allowedECNames')]" }
    })
    reference_id = null
  }
  

  parameters = <<PARAMETERS
{
    "requiredRetentionDays": {
        "name": "requiredRetentionDays",
        "type": "String",
        "description": "The required resource logs retention in days",
        "display_name": "Required retention (days)",
        "default_value": "365"
    },
    "allowedCAs": {
        "name": "allowedCAs",
        "type": "Array",
        "description": "The list of allowed certificate authorities supported by Azure Key Vault.",
        "display_name": "Allowed Azure Key Vault Supported CAs",
        "default_value": [
            "DigiCert",
            "GlobalSign"
        ],
        "allowed_values": [
            "DigiCert",
            "GlobalSign"
        ]
    },
    "maximumValidityInMonths": {
        "name": "maximumValidityInMonths",
        "type": "Integer",
        "description": "The limit to how long a certificate may be valid for. Certificates with lengthy validity periods aren't best practice.",
        "display_name": "The maximum validity in months",
        "default_value": 12
    },
    "allowedKeyTypes": {
        "name": "allowedKeyTypes",
        "type": "Array",
        "description": "The list of allowed key types",
        "display_name": "Allowed key types",
        "default_value": [
            "RSA",
            "RSA-HSM",
            "EC",
            "EC-HSM"
        ],
        "allowed_values": [
            "RSA",
            "RSA-HSM",
            "EC",
            "EC-HSM"
        ]
    },
    "allowedECNames": {
        "name": "allowedECNames",
        "type": "Array",
        "description": "The list of allowed curve names for elliptic curve cryptography certificates.",
        "display_name": "Allowed elliptic curve names",
        "default_value": [
            "P-256",
            "P-256K",
            "P-384",
            "P-521"
        ],
        "allowed_values": [
            "P-256",
            "P-256K",
            "P-384",
            "P-521"
        ]
    }
}
PARAMETERS
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example-params_guardrails" {
  name                 = var.name
  policy_definition_id = azurerm_policy_set_definition.example-params_guardrails.id
  scope                = local.scope
  enforcement_mode     = var.enforcement_mode
  parameters = jsonencode({
    requiredRetentionDays = { "value" = "365" }
    requiredRetentionDays = { "value" = "365" }
    allowedCAs = { "value" = ["DigiCert", "GlobalSign"] }
    maximumValidityInMonths = { "value" = 12 }
    allowedKeyTypes = { "value" = ["RSA", "RSA-HSM"] }
    allowedECNames = { "value" = ["P-256", "P-256K", "P-384", "P-521"] }
    allowedKeyTypes = { "value" = ["RSA", "RSA-HSM", "EC", "EC-HSM"] }
    allowedECNames = { "value" = ["P-256", "P-256K", "P-384", "P-521"] }

})
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
//output "policy_assignment_ids" {
//  value       = azurerm_policy_assignment.example-params_guardrails.*.id
//  description = "The IDs of the Policy Assignments."
//}
//
//output "scope" {
//  value       = local.scope
//  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
//}
//
//output "policy_set_definition_id" {
//  value       = azurerm_policy_set_definition.example-params_guardrails.id
//  description = "The ID of the Policy Set Definition."
//}