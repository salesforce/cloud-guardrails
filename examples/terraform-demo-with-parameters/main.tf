locals {
  name_example_PO = "example_PO"
  subscription_name_example_PO = "example"
  management_group_example_PO = ""
  category_example_PO = "Testing"
  enforcement_mode_example_PO = false
  policy_ids_example_PO = [
    # -----------------------------------------------------------------------------------------------------------------
    # API Management
    # -----------------------------------------------------------------------------------------------------------------
    "73ef9241-5d81-4cd4-b483-8443d1730fe5", # API Management service should use a SKU that supports virtual networks

    # -----------------------------------------------------------------------------------------------------------------
    # App Service
    # -----------------------------------------------------------------------------------------------------------------
    "88999f4c-376a-45c8-bcb3-4058f713cf39", # Ensure that 'Java version' is the latest, if used as a part of the API app
    "9d0b6ea4-93e2-4578-bf2f-6bb17d22b4bc", # Ensure that 'Java version' is the latest, if used as a part of the Function app
    "496223c3-ad65-4ecd-878a-bae78737e9ed", # Ensure that 'Java version' is the latest, if used as a part of the Web app
    "1bc1795e-d44a-4d48-9b3b-6fff0fd5f9ba", # Ensure that 'PHP version' is the latest, if used as a part of the API app
    "7261b898-8a84-4db8-9e04-18527132abb3", # Ensure that 'PHP version' is the latest, if used as a part of the WEB app
    "74c3584d-afae-46f7-a20a-6f8adba71a16", # Ensure that 'Python version' is the latest, if used as a part of the API app
    "7238174a-fd10-4ef0-817e-fc820a951d73", # Ensure that 'Python version' is the latest, if used as a part of the Function app
    "7008174a-fd10-4ef0-817e-fc820a951d73", # Ensure that 'Python version' is the latest, if used as a part of the Web app
    "91a78b24-f231-4a8a-8da9-02c35b2b6510", # Resource logs in App Services should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "428256e6-1fac-4f48-a757-df34c2b3336d", # Resource logs in Batch accounts should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Data Box
    # -----------------------------------------------------------------------------------------------------------------
    "c349d81b-9985-44ae-a8da-ff98d108ede8", # Azure Data Box jobs should enable double encryption for data at rest on the device
    "86efb160-8de7-451d-bc08-5d475b0aadae", # Azure Data Box jobs should use a customer-managed key to encrypt the device unlock password

    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "85bb39b5-2f66-49f8-9306-77da3ac5130f", # [Preview]: Azure Data Factory integration runtime should have a limit for number of cores

    # -----------------------------------------------------------------------------------------------------------------
    # Data Lake
    # -----------------------------------------------------------------------------------------------------------------
    "057ef27e-665e-4328-8ea3-04b3122bd9fb", # Resource logs in Azure Data Lake Store should be enabled
    "c95c74d9-38fe-4f0d-af86-0c7d626a315c", # Resource logs in Data Lake Analytics should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Event Hub
    # -----------------------------------------------------------------------------------------------------------------
    "83a214f7-d01a-484b-91a9-ed54470c9a6a", # Resource logs in Event Hub should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Internet of Things
    # -----------------------------------------------------------------------------------------------------------------
    "383856f8-de7f-44a2-81fc-e5135b5c2aa4", # Resource logs in IoT Hub should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "a2a5b911-5617-447e-a49e-59dbe0e0434b", # Resource logs in Azure Key Vault Managed HSM should be enabled
    "cf820ca0-f99e-4f3e-84fb-66e913812d21", # Resource logs in Key Vault should be enabled
    "8e826246-c976-48f6-b03e-619bb92b3d82", # [Preview]: Certificates should be issued by the specified integrated certificate authority
    "0a075868-4c26-42ef-914c-5bc007359560", # [Preview]: Certificates should have the specified maximum validity period
    "1151cede-290b-4ba0-8b38-0ad145ac888f", # [Preview]: Certificates should use allowed key types
    "bd78111f-4953-4367-9fd5-7e08808b54bf", # [Preview]: Certificates using elliptic curve cryptography should have allowed curve names
    "75c4f823-d65c-4f29-a733-01d0077fdbcb", # [Preview]: Keys should be the specified cryptographic type RSA or EC
    "ff25f3c8-b739-4538-9d07-3d6d25cfb255", # [Preview]: Keys using elliptic curve cryptography should have the specified curve names

    # -----------------------------------------------------------------------------------------------------------------
    # Logic Apps
    # -----------------------------------------------------------------------------------------------------------------
    "34f95f76-5386-4de7-b824-0d8478470c9d", # Resource logs in Logic Apps should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "12430be1-6cc8-4527-a9a8-e3d38f250096", # Web Application Firewall (WAF) should use the specified mode for Application Gateway
    "425bea59-a659-4cbb-8d31-34499bd030b8", # Web Application Firewall (WAF) should use the specified mode for Azure Front Door Service

    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9", # Auditing on SQL server should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Search
    # -----------------------------------------------------------------------------------------------------------------
    "b4330a05-a843-4bc8-bf9a-cacce50c67f4", # Resource logs in Search services should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Service Bus
    # -----------------------------------------------------------------------------------------------------------------
    "f8d36e2f-389b-4ee4-898d-21aeb69a0f45", # Resource logs in Service Bus should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Stream Analytics
    # -----------------------------------------------------------------------------------------------------------------
    "f9be5368-9bf5-4b84-9e0a-7850da98bb46", # Resource logs in Azure Stream Analytics should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Synapse
    # -----------------------------------------------------------------------------------------------------------------
    "e04e5000-cd89-451d-bb21-a14d24ff9c73", # Auditing on Synapse workspace should be enabled

  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.example_PO_definition_lookups.*.display_name,
    data.azurerm_policy_definition.example_PO_definition_lookups.*.id
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_PO" {
  count = local.management_group_example_PO != "" ? 1 : 0
  display_name  = local.management_group_example_PO
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_PO" {
  count                 = local.subscription_name_example_PO != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_PO
}

locals {
  scope = local.management_group_example_PO != "" ? data.azurerm_management_group.example_PO[0].id : element(data.azurerm_subscriptions.example_PO[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_PO_definition_lookups" {
  count = length(local.policy_ids_example_PO)
  name  = local.policy_ids_example_PO[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_PO" {
  name                  = local.name_example_PO
  policy_type           = "Custom"
  display_name          = local.name_example_PO
  description           = local.name_example_PO
  management_group_name = local.management_group_example_PO == "" ? null : local.management_group_example_PO
  metadata = tostring(jsonencode({
    category = local.category_example_PO
  }))



  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "API Management service should use a SKU that supports virtual networks")
    parameter_values = jsonencode({
      listOfAllowedSKUs = { "value" : "[parameters('listOfAllowedSKUs')]" }
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


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Auditing on Synapse workspace should be enabled")
    parameter_values = jsonencode({
      setting = { "value" : "[parameters('setting')]" }
    })
    reference_id = null
  }


  parameters = <<PARAMETERS
{
    "listOfAllowedSKUs": {
        "name": "listOfAllowedSKUs",
        "type": "Array",
        "description": "The list of SKUs that can be specified for Azure API Management service.",
        "display_name": "Allowed SKUs",
        "default_value": [
            "Developer",
            "Premium",
            "Isolated"
        ],
        "allowed_values": [
            "Developer",
            "Basic",
            "Standard",
            "Premium",
            "Isolated",
            "Consumption"
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
        "default_value": "3.9"
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
resource "azurerm_policy_assignment" "example_PO" {
  name                 = local.name_example_PO
  policy_definition_id = azurerm_policy_set_definition.example_PO.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_PO
  parameters = jsonencode({
    listOfAllowedSKUs = { "value" = ["Developer", "Premium", "Isolated"] }
	JavaLatestVersion = { "value" = "11" }
	PHPLatestVersion = { "value" = "7.3" }
	WindowsPythonLatestVersion = { "value" = "3.6" }
	LinuxPythonLatestVersion = { "value" = "3.9" }
	requiredRetentionDays = { "value" = "365" }
	supportedSKUs = { "value" = ["DataBox", "DataBoxHeavy"] }
	maxCores = { "value" = 32 }
	allowedCAs = { "value" = ["DigiCert", "GlobalSign"] }
	maximumValidityInMonths = { "value" = 12 }
	allowedKeyTypes = { "value" = ["RSA", "RSA-HSM"] }
	allowedECNames = { "value" = ["P-256", "P-256K", "P-384", "P-521"] }
	modeRequirement = { "value" = "Detection" }
	setting = { "value" = "enabled" }
})
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "example_PO_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_PO.id
  description = "The IDs of the Policy Assignments."
}

output "example_PO_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_PO_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_PO.id
  description = "The ID of the Policy Set Definition."
}
