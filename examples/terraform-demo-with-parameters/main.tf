variable "name" { default = "GrdRlz-example-params" }
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
    # API Management
    # -----------------------------------------------------------------------------------------------------------------
    "API Management services should use a virtual network",
    # -----------------------------------------------------------------------------------------------------------------
    # App Platform
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Spring Cloud should use network injection",
    # -----------------------------------------------------------------------------------------------------------------
    # App Service
    # -----------------------------------------------------------------------------------------------------------------
    "Ensure that 'Java version' is the latest, if used as a part of the API app",
    "Ensure that 'Java version' is the latest, if used as a part of the Function app",
    "Ensure that 'Java version' is the latest, if used as a part of the Web app",
    "Ensure that 'PHP version' is the latest, if used as a part of the API app",
    "Ensure that 'PHP version' is the latest, if used as a part of the WEB app",
    "Ensure that 'Python version' is the latest, if used as a part of the API app",
    "Ensure that 'Python version' is the latest, if used as a part of the Function app",
    "Ensure that 'Python version' is the latest, if used as a part of the Web app",
    "Resource logs in App Services should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Batch accounts should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Data Box
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Data Box jobs should enable double encryption for data at rest on the device",
    "Azure Data Box jobs should use a customer-managed key to encrypt the device unlock password",
    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "[Preview]: Azure Data Factory integration runtime should have a limit for number of cores",
    # -----------------------------------------------------------------------------------------------------------------
    # Data Lake
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Azure Data Lake Store should be enabled",
    "Resource logs in Data Lake Analytics should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Event Hub
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Event Hub should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Internet of Things
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in IoT Hub should be enabled",
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
    # -----------------------------------------------------------------------------------------------------------------
    # Logic Apps
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Logic Apps should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "Web Application Firewall (WAF) should use the specified mode for Application Gateway",
    "Web Application Firewall (WAF) should use the specified mode for Azure Front Door Service",
    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "Auditing on SQL server should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Search
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Search services should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Service Bus
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Service Bus should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Stream Analytics
    # -----------------------------------------------------------------------------------------------------------------
    "Resource logs in Azure Stream Analytics should be enabled",
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.GrdRlz_example_params_definition_lookups.*.display_name,
    data.azurerm_policy_definition.GrdRlz_example_params_definition_lookups.*.id
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "GrdRlz_example_params" {
  count = var.management_group != "" ? 1 : 0
  name  = var.management_group
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "GrdRlz_example_params" {
  count                 = var.subscription_name != "" ? 1 : 0
  display_name_contains = var.subscription_name
}

locals {
  scope = var.management_group != "" ? data.azurerm_management_group.GrdRlz_example_params[0].id : element(data.azurerm_subscriptions.GrdRlz_example_params[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "GrdRlz_example_params_definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "GrdRlz_example_params_guardrails" {
  name                  = var.name
  policy_type           = "Custom"
  display_name          = var.name
  description           = var.name
  management_group_name = var.management_group == "" ? null : var.management_group
  metadata = tostring(jsonencode({
    category = var.category
  }))


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "API Management services should use a virtual network")
    parameter_values = jsonencode({
      evaluatedSkuNames = { "value" : "[parameters('evaluatedSkuNames')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Spring Cloud should use network injection")
    parameter_values = jsonencode({
      evaluatedSkuNames = { "value" : "[parameters('evaluatedSkuNames')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Java version' is the latest, if used as a part of the API app")
    parameter_values = jsonencode({
      JavaLatestVersion = { "value" : "[parameters('JavaLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Java version' is the latest, if used as a part of the Function app")
    parameter_values = jsonencode({
      JavaLatestVersion = { "value" : "[parameters('JavaLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Java version' is the latest, if used as a part of the Web app")
    parameter_values = jsonencode({
      JavaLatestVersion = { "value" : "[parameters('JavaLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'PHP version' is the latest, if used as a part of the API app")
    parameter_values = jsonencode({
      PHPLatestVersion = { "value" : "[parameters('PHPLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'PHP version' is the latest, if used as a part of the WEB app")
    parameter_values = jsonencode({
      PHPLatestVersion = { "value" : "[parameters('PHPLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Python version' is the latest, if used as a part of the API app")
    parameter_values = jsonencode({
      WindowsPythonLatestVersion = { "value" : "[parameters('WindowsPythonLatestVersion')]" }
      LinuxPythonLatestVersion = { "value" : "[parameters('LinuxPythonLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Python version' is the latest, if used as a part of the Function app")
    parameter_values = jsonencode({
      WindowsPythonLatestVersion = { "value" : "[parameters('WindowsPythonLatestVersion')]" }
      LinuxPythonLatestVersion = { "value" : "[parameters('LinuxPythonLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Ensure that 'Python version' is the latest, if used as a part of the Web app")
    parameter_values = jsonencode({
      WindowsPythonLatestVersion = { "value" : "[parameters('WindowsPythonLatestVersion')]" }
      LinuxPythonLatestVersion = { "value" : "[parameters('LinuxPythonLatestVersion')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in App Services should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Batch accounts should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Data Box jobs should enable double encryption for data at rest on the device")
    parameter_values = jsonencode({
      supportedSKUs = { "value" : "[parameters('supportedSKUs')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Data Box jobs should use a customer-managed key to encrypt the device unlock password")
    parameter_values = jsonencode({
      supportedSKUs = { "value" : "[parameters('supportedSKUs')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Azure Data Factory integration runtime should have a limit for number of cores")
    parameter_values = jsonencode({
      maxCores = { "value" : "[parameters('maxCores')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Azure Data Lake Store should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Data Lake Analytics should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Event Hub should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in IoT Hub should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

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

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Logic Apps should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Web Application Firewall (WAF) should use the specified mode for Application Gateway")
    parameter_values = jsonencode({
      modeRequirement = { "value" : "[parameters('modeRequirement')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Web Application Firewall (WAF) should use the specified mode for Azure Front Door Service")
    parameter_values = jsonencode({
      modeRequirement = { "value" : "[parameters('modeRequirement')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Auditing on SQL server should be enabled")
    parameter_values = jsonencode({
      setting = { "value" : "[parameters('setting')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Search services should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Service Bus should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Azure Stream Analytics should be enabled")
    parameter_values = jsonencode({
      requiredRetentionDays = { "value" : "[parameters('requiredRetentionDays')]" }
    })
    reference_id = null
  }


  parameters = <<PARAMETERS
{
    "evaluatedSkuNames": {
        "name": "evaluatedSkuNames",
        "type": "Array",
        "description": "List of Azure Spring Cloud SKUs against which this policy will be evaluated.",
        "display_name": "Azure Spring Cloud SKU Names",
        "default_value": [
            "Standard"
        ],
        "allowed_values": [
            "Standard"
        ]
    },
    "JavaLatestVersion": {
        "name": "JavaLatestVersion",
        "type": "String",
        "description": "Latest supported Java version for App Services",
        "display_name": "Latest Java version",
        "default_value": "11"
    },
    "PHPLatestVersion": {
        "name": "PHPLatestVersion",
        "type": "String",
        "description": "Latest supported PHP version for App Services",
        "display_name": "Latest PHP version",
        "default_value": "7.3"
    },
    "WindowsPythonLatestVersion": {
        "name": "WindowsPythonLatestVersion",
        "type": "String",
        "description": "Latest supported Python version for App Services",
        "display_name": "Latest Windows Python version",
        "default_value": "3.6"
    },
    "LinuxPythonLatestVersion": {
        "name": "LinuxPythonLatestVersion",
        "type": "String",
        "description": "Latest supported Python version for App Services",
        "display_name": "Linux Latest Python version",
        "default_value": "3.8"
    },
    "requiredRetentionDays": {
        "name": "requiredRetentionDays",
        "type": "String",
        "description": "The required resource logs retention in days",
        "display_name": "Required retention (days)",
        "default_value": "365"
    },
    "supportedSKUs": {
        "name": "supportedSKUs",
        "type": "Array",
        "description": "The list of SKUs that support customer-managed key encryption key",
        "display_name": "Supported SKUs",
        "default_value": [
            "DataBox",
            "DataBoxHeavy"
        ],
        "allowed_values": [
            "DataBox",
            "DataBoxHeavy"
        ]
    },
    "maxCores": {
        "name": "maxCores",
        "type": "Integer",
        "description": "The max number of cores allowed for dataflow.",
        "display_name": "Allowed max number of cores",
        "default_value": 32
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
    },
    "modeRequirement": {
        "name": "modeRequirement",
        "type": "String",
        "description": "Mode required for all WAF policies",
        "display_name": "Mode Requirement",
        "default_value": "Detection",
        "allowed_values": [
            "Prevention",
            "Detection"
        ]
    },
    "setting": {
        "name": "setting",
        "type": "String",
        "description": null,
        "display_name": "Desired Auditing setting",
        "default_value": "enabled",
        "allowed_values": [
            "enabled",
            "disabled"
        ]
    }
}
PARAMETERS
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
//resource "azurerm_policy_assignment" "GrdRlz_example_params_guardrails" {
//  name                 = var.name
//  policy_definition_id = azurerm_policy_set_definition.GrdRlz_example_params_guardrails.id
//  scope                = local.scope
//  enforcement_mode     = var.enforcement_mode
//}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
//output "policy_assignment_ids" {
//  value       = azurerm_policy_assignment.GrdRlz_example_params_guardrails.*.id
//  description = "The IDs of the Policy Assignments."
//}
//
//output "scope" {
//  value       = local.scope
//  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
//}
//
//output "policy_set_definition_id" {
//  value       = azurerm_policy_set_definition.GrdRlz_example_params_guardrails.id
//  description = "The ID of the Policy Set Definition."
//}
