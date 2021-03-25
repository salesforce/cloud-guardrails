locals {
  name_example_PO_Audit = "example_PO_Audit"
  subscription_name_example_PO_Audit = "example"
  management_group_example_PO_Audit = ""
  category_example_PO_Audit = "Testing"
  enforcement_mode_example_PO_Audit = false
  policy_ids_example_PO_Audit = [
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
    # Guest Configuration
    # -----------------------------------------------------------------------------------------------------------------
    "ea53dbee-c6c9-4f0e-9f9e-de0039b78023", # Audit Linux machines that allow remote connections from accounts without passwords 
    "e6955644-301c-44b5-a4c4-528577de6861", # Audit Linux machines that do not have the passwd file permissions set to 0644 
    "f6ec09a3-78bf-4f8f-99dc-6c77182d0f99", # Audit Linux machines that have accounts without passwords 
    "4221adbc-5c0f-474f-88b7-037a99e6114c", # Audit Windows VMs with a pending reboot 
    "58c460e9-7573-4bb2-9676-339c2f2486bb", # Audit Windows machines on which Windows Serial Console is not enabled 
    "08a2f2d2-94b2-4a7b-aa3b-bb3f523ee6fd", # Audit Windows machines on which the DSC configuration is not compliant 
    "5b054a0d-39e2-4d53-bea3-9734cad2c69b", # Audit Windows machines that allow re-use of the previous 24 passwords 
    "4ceb8dc2-559c-478b-a15b-733fbf1e3738", # Audit Windows machines that do not have a maximum password age of 70 days 
    "237b38db-ca4d-4259-9e47-7882441ca2c0", # Audit Windows machines that do not have a minimum password age of 1 day 
    "bf16e0bb-31e1-4646-8202-60a235cc7e74", # Audit Windows machines that do not have the password complexity setting enabled 
    "a2d0e922-65d0-40c4-8f87-ea6da2d307a2", # Audit Windows machines that do not restrict the minimum password length to 14 characters 
    "da0f98fe-a24b-4ad5-af69-bd0400233661", # Audit Windows machines that do not store passwords using reversible encryption 
    "3d2a3320-2a72-4c67-ac5f-caa40fbee2b2", # Audit Windows machines that have extra accounts in the Administrators group 
    "beb6ccee-b6b8-4e91-9801-a5fa4260a104", # Audit Windows machines that have not restarted within the specified number of days 
    "630c64f9-8b6b-4c64-b511-6544ceff6fd6", # Authentication to Linux machines should require SSH keys 
    "bed48b13-6647-468e-aa2f-1af1d3f4dd40", # Windows Defender Exploit Guard should be enabled on your machines 
    "3aa2661b-02d7-4ba6-99bc-dc36b10489fd", # Windows machines should meet requirements for 'Administrative Templates - Control Panel' 
    "e0a7e899-2ce2-4253-8a13-d808fdeb75af", # Windows machines should meet requirements for 'Administrative Templates - MSS (Legacy)' 
    "67e010c1-640d-438e-a3a5-feaccb533a98", # Windows machines should meet requirements for 'Administrative Templates - Network' 
    "968410dc-5ca0-4518-8a5b-7b55f0530ea9", # Windows machines should meet requirements for 'Administrative Templates - System' 
    "ee984370-154a-4ee8-9726-19d900e56fc0", # Windows machines should meet requirements for 'Security Options - Accounts' 
    "33936777-f2ac-45aa-82ec-07958ec9ade4", # Windows machines should meet requirements for 'Security Options - Audit' 
    "8794ff4f-1a35-4e18-938f-0b22055067cd", # Windows machines should meet requirements for 'Security Options - Devices' 
    "d472d2c9-d6a3-4500-9f5f-b15f123005aa", # Windows machines should meet requirements for 'Security Options - Interactive Logon' 
    "d6c69680-54f0-4349-af10-94dd05f4225e", # Windows machines should meet requirements for 'Security Options - Microsoft Network Client' 
    "caf2d518-f029-4f6b-833b-d7081702f253", # Windows machines should meet requirements for 'Security Options - Microsoft Network Server' 
    "3ff60f98-7fa4-410a-9f7f-0b00f5afdbdd", # Windows machines should meet requirements for 'Security Options - Network Access' 
    "1221c620-d201-468c-81e7-2817e6107e84", # Windows machines should meet requirements for 'Security Options - Network Security' 
    "f71be03e-e25b-4d0f-b8bc-9b3e309b66c0", # Windows machines should meet requirements for 'Security Options - Recovery console' 
    "b4a4d1eb-0263-441b-84cb-a44073d8372d", # Windows machines should meet requirements for 'Security Options - Shutdown' 
    "2f262ace-812a-4fd0-b731-b38ba9e9708d", # Windows machines should meet requirements for 'Security Options - System objects' 
    "12017595-5a75-4bb1-9d97-4c2c939ea3c3", # Windows machines should meet requirements for 'Security Options - System settings' 
    "492a29ed-d143-4f03-b6a4-705ce081b463", # Windows machines should meet requirements for 'Security Options - User Account Control' 
    "f2143251-70de-4e81-87a8-36cee5a2f29d", # Windows machines should meet requirements for 'Security Settings - Account Policies' 
    "43bb60fe-1d7e-4b82-9e93-496bfc99e7d5", # Windows machines should meet requirements for 'System Audit Policies - Account Logon' 
    "94d9aca8-3757-46df-aa51-f218c5f11954", # Windows machines should meet requirements for 'System Audit Policies - Account Management' 
    "58383b73-94a9-4414-b382-4146eb02611b", # Windows machines should meet requirements for 'System Audit Policies - Detailed Tracking' 
    "19be9779-c776-4dfa-8a15-a2fd5dc843d6", # Windows machines should meet requirements for 'System Audit Policies - Logon-Logoff' 
    "35781875-8026-4628-b19b-f6efb4d88a1d", # Windows machines should meet requirements for 'System Audit Policies - Object Access' 
    "2a7a701e-dff3-4da9-9ec5-42cb98594c0b", # Windows machines should meet requirements for 'System Audit Policies - Policy Change' 
    "87845465-c458-45f3-af66-dcd62176f397", # Windows machines should meet requirements for 'System Audit Policies - Privilege Use' 
    "8316fa92-d69c-4810-8124-62414f560dcf", # Windows machines should meet requirements for 'System Audit Policies - System' 
    "e068b215-0026-4354-b347-8fb2766f73a2", # Windows machines should meet requirements for 'User Rights Assignment' 
    "8537fe96-8cbe-43de-b0ef-131bc72bc22a", # Windows machines should meet requirements for 'Windows Components' 
    "35d9882c-993d-44e6-87d2-db66ce21b636", # Windows machines should meet requirements for 'Windows Firewall Properties' 
    "5752e6d6-1206-46d8-8ab1-ecc2f71a8112", # Windows web servers should be configured to use secure communication protocols 
    "fc9b3da7-8347-4380-8e70-0a0361d8dedd", # [Preview]: Linux machines should meet requirements for the Azure security baseline 
    "72650e9f-97bc-4b2a-ab5f-9781a9fcecbc", # [Preview]: Windows machines should meet requirements of the Azure Security Center baseline 
    
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
    data.azurerm_policy_definition.example_PO_Audit_definition_lookups.*.display_name,
    data.azurerm_policy_definition.example_PO_Audit_definition_lookups.*.id
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_PO_Audit" {
  count = local.management_group_example_PO_Audit != "" ? 1 : 0
  display_name  = local.management_group_example_PO_Audit
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_PO_Audit" {
  count                 = local.subscription_name_example_PO_Audit != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_PO_Audit
}

locals {
  scope = local.management_group_example_PO_Audit != "" ? data.azurerm_management_group.example_PO_Audit[0].id : element(data.azurerm_subscriptions.example_PO_Audit[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_PO_Audit_definition_lookups" {
  count = length(local.policy_ids_example_PO_Audit)
  name  = local.policy_ids_example_PO_Audit[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_PO_Audit" {
  name                  = local.name_example_PO_Audit
  policy_type           = "Custom"
  display_name          = local.name_example_PO_Audit
  description           = local.name_example_PO_Audit
  management_group_name = local.management_group_example_PO_Audit == "" ? null : local.management_group_example_PO_Audit
  metadata = tostring(jsonencode({
    category = local.category_example_PO_Audit
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
    policy_definition_id = lookup(local.policy_definition_map, "Audit Linux machines that allow remote connections from accounts without passwords")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Linux machines that do not have the passwd file permissions set to 0644")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Linux machines that have accounts without passwords")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows VMs with a pending reboot")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines on which Windows Serial Console is not enabled")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      EMSPortNumber = { "value" : "[parameters('EMSPortNumber')]" }
      EMSBaudRate = { "value" : "[parameters('EMSBaudRate')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines on which the DSC configuration is not compliant")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that allow re-use of the previous 24 passwords")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not have a maximum password age of 70 days")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not have a minimum password age of 1 day")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not have the password complexity setting enabled")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not restrict the minimum password length to 14 characters")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not store passwords using reversible encryption")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that have extra accounts in the Administrators group")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      Members = { "value" : "[parameters('Members')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that have not restarted within the specified number of days")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      NumberOfDays = { "value" : "[parameters('NumberOfDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Authentication to Linux machines should require SSH keys")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows Defender Exploit Guard should be enabled on your machines")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      NotAvailableMachineState = { "value" : "[parameters('NotAvailableMachineState')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Administrative Templates - Control Panel'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Administrative Templates - MSS (Legacy)'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Administrative Templates - Network'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      EnableInsecureGuestLogons = { "value" : "[parameters('EnableInsecureGuestLogons')]" }
      AllowSimultaneousConnectionsToTheInternetOrAWindowsDomain = { "value" : "[parameters('AllowSimultaneousConnectionsToTheInternetOrAWindowsDomain')]" }
      TurnOffMulticastNameResolution = { "value" : "[parameters('TurnOffMulticastNameResolution')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Administrative Templates - System'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AlwaysUseClassicLogon = { "value" : "[parameters('AlwaysUseClassicLogon')]" }
      BootStartDriverInitializationPolicy = { "value" : "[parameters('BootStartDriverInitializationPolicy')]" }
      EnableWindowsNTPClient = { "value" : "[parameters('EnableWindowsNTPClient')]" }
      TurnOnConveniencePINSignin = { "value" : "[parameters('TurnOnConveniencePINSignin')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Accounts'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AccountsGuestAccountStatus = { "value" : "[parameters('AccountsGuestAccountStatus')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Audit'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditShutDownSystemImmediatelyIfUnableToLogSecurityAudits = { "value" : "[parameters('AuditShutDownSystemImmediatelyIfUnableToLogSecurityAudits')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Devices'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      DevicesAllowedToFormatAndEjectRemovableMedia = { "value" : "[parameters('DevicesAllowedToFormatAndEjectRemovableMedia')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Interactive Logon'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Microsoft Network Client'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      MicrosoftNetworkClientDigitallySignCommunicationsAlways = { "value" : "[parameters('MicrosoftNetworkClientDigitallySignCommunicationsAlways')]" }
      MicrosoftNetworkClientSendUnencryptedPasswordToThirdpartySMBServers = { "value" : "[parameters('MicrosoftNetworkClientSendUnencryptedPasswordToThirdpartySMBServers')]" }
      MicrosoftNetworkServerAmountOfIdleTimeRequiredBeforeSuspendingSession = { "value" : "[parameters('MicrosoftNetworkServerAmountOfIdleTimeRequiredBeforeSuspendingSession')]" }
      MicrosoftNetworkServerDigitallySignCommunicationsAlways = { "value" : "[parameters('MicrosoftNetworkServerDigitallySignCommunicationsAlways')]" }
      MicrosoftNetworkServerDisconnectClientsWhenLogonHoursExpire = { "value" : "[parameters('MicrosoftNetworkServerDisconnectClientsWhenLogonHoursExpire')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Microsoft Network Server'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Network Access'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      NetworkAccessRemotelyAccessibleRegistryPaths = { "value" : "[parameters('NetworkAccessRemotelyAccessibleRegistryPaths')]" }
      NetworkAccessRemotelyAccessibleRegistryPathsAndSubpaths = { "value" : "[parameters('NetworkAccessRemotelyAccessibleRegistryPathsAndSubpaths')]" }
      NetworkAccessSharesThatCanBeAccessedAnonymously = { "value" : "[parameters('NetworkAccessSharesThatCanBeAccessedAnonymously')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Network Security'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      NetworkSecurityConfigureEncryptionTypesAllowedForKerberos = { "value" : "[parameters('NetworkSecurityConfigureEncryptionTypesAllowedForKerberos')]" }
      NetworkSecurityLANManagerAuthenticationLevel = { "value" : "[parameters('NetworkSecurityLANManagerAuthenticationLevel')]" }
      NetworkSecurityLDAPClientSigningRequirements = { "value" : "[parameters('NetworkSecurityLDAPClientSigningRequirements')]" }
      NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCClients = { "value" : "[parameters('NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCClients')]" }
      NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCServers = { "value" : "[parameters('NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCServers')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Recovery console'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      RecoveryConsoleAllowFloppyCopyAndAccessToAllDrivesAndAllFolders = { "value" : "[parameters('RecoveryConsoleAllowFloppyCopyAndAccessToAllDrivesAndAllFolders')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - Shutdown'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ShutdownAllowSystemToBeShutDownWithoutHavingToLogOn = { "value" : "[parameters('ShutdownAllowSystemToBeShutDownWithoutHavingToLogOn')]" }
      ShutdownClearVirtualMemoryPagefile = { "value" : "[parameters('ShutdownClearVirtualMemoryPagefile')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - System objects'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - System settings'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      SystemSettingsUseCertificateRulesOnWindowsExecutablesForSoftwareRestrictionPolicies = { "value" : "[parameters('SystemSettingsUseCertificateRulesOnWindowsExecutablesForSoftwareRestrictionPolicies')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Options - User Account Control'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      UACAdminApprovalModeForTheBuiltinAdministratorAccount = { "value" : "[parameters('UACAdminApprovalModeForTheBuiltinAdministratorAccount')]" }
      UACBehaviorOfTheElevationPromptForAdministratorsInAdminApprovalMode = { "value" : "[parameters('UACBehaviorOfTheElevationPromptForAdministratorsInAdminApprovalMode')]" }
      UACDetectApplicationInstallationsAndPromptForElevation = { "value" : "[parameters('UACDetectApplicationInstallationsAndPromptForElevation')]" }
      UACRunAllAdministratorsInAdminApprovalMode = { "value" : "[parameters('UACRunAllAdministratorsInAdminApprovalMode')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Security Settings - Account Policies'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      EnforcePasswordHistory = { "value" : "[parameters('EnforcePasswordHistory')]" }
      MaximumPasswordAge = { "value" : "[parameters('MaximumPasswordAge')]" }
      MinimumPasswordAge = { "value" : "[parameters('MinimumPasswordAge')]" }
      MinimumPasswordLength = { "value" : "[parameters('MinimumPasswordLength')]" }
      PasswordMustMeetComplexityRequirements = { "value" : "[parameters('PasswordMustMeetComplexityRequirements')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Account Logon'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditCredentialValidation = { "value" : "[parameters('AuditCredentialValidation')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Account Management'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Detailed Tracking'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditProcessTermination = { "value" : "[parameters('AuditProcessTermination')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Logon-Logoff'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditGroupMembership = { "value" : "[parameters('AuditGroupMembership')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Object Access'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditDetailedFileShare = { "value" : "[parameters('AuditDetailedFileShare')]" }
      AuditFileShare = { "value" : "[parameters('AuditFileShare')]" }
      AuditFileSystem = { "value" : "[parameters('AuditFileSystem')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Policy Change'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditAuthenticationPolicyChange = { "value" : "[parameters('AuditAuthenticationPolicyChange')]" }
      AuditAuthorizationPolicyChange = { "value" : "[parameters('AuditAuthorizationPolicyChange')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - Privilege Use'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'System Audit Policies - System'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      AuditOtherSystemEvents = { "value" : "[parameters('AuditOtherSystemEvents')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'User Rights Assignment'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      UsersOrGroupsThatMayAccessThisComputerFromTheNetwork = { "value" : "[parameters('UsersOrGroupsThatMayAccessThisComputerFromTheNetwork')]" }
      UsersOrGroupsThatMayLogOnLocally = { "value" : "[parameters('UsersOrGroupsThatMayLogOnLocally')]" }
      UsersOrGroupsThatMayLogOnThroughRemoteDesktopServices = { "value" : "[parameters('UsersOrGroupsThatMayLogOnThroughRemoteDesktopServices')]" }
      UsersAndGroupsThatAreDeniedAccessToThisComputerFromTheNetwork = { "value" : "[parameters('UsersAndGroupsThatAreDeniedAccessToThisComputerFromTheNetwork')]" }
      UsersOrGroupsThatMayManageAuditingAndSecurityLog = { "value" : "[parameters('UsersOrGroupsThatMayManageAuditingAndSecurityLog')]" }
      UsersOrGroupsThatMayBackUpFilesAndDirectories = { "value" : "[parameters('UsersOrGroupsThatMayBackUpFilesAndDirectories')]" }
      UsersOrGroupsThatMayChangeTheSystemTime = { "value" : "[parameters('UsersOrGroupsThatMayChangeTheSystemTime')]" }
      UsersOrGroupsThatMayChangeTheTimeZone = { "value" : "[parameters('UsersOrGroupsThatMayChangeTheTimeZone')]" }
      UsersOrGroupsThatMayCreateATokenObject = { "value" : "[parameters('UsersOrGroupsThatMayCreateATokenObject')]" }
      UsersAndGroupsThatAreDeniedLoggingOnAsABatchJob = { "value" : "[parameters('UsersAndGroupsThatAreDeniedLoggingOnAsABatchJob')]" }
      UsersAndGroupsThatAreDeniedLoggingOnAsAService = { "value" : "[parameters('UsersAndGroupsThatAreDeniedLoggingOnAsAService')]" }
      UsersAndGroupsThatAreDeniedLocalLogon = { "value" : "[parameters('UsersAndGroupsThatAreDeniedLocalLogon')]" }
      UsersAndGroupsThatAreDeniedLogOnThroughRemoteDesktopServices = { "value" : "[parameters('UsersAndGroupsThatAreDeniedLogOnThroughRemoteDesktopServices')]" }
      UserAndGroupsThatMayForceShutdownFromARemoteSystem = { "value" : "[parameters('UserAndGroupsThatMayForceShutdownFromARemoteSystem')]" }
      UsersAndGroupsThatMayRestoreFilesAndDirectories = { "value" : "[parameters('UsersAndGroupsThatMayRestoreFilesAndDirectories')]" }
      UsersAndGroupsThatMayShutDownTheSystem = { "value" : "[parameters('UsersAndGroupsThatMayShutDownTheSystem')]" }
      UsersOrGroupsThatMayTakeOwnershipOfFilesOrOtherObjects = { "value" : "[parameters('UsersOrGroupsThatMayTakeOwnershipOfFilesOrOtherObjects')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Windows Components'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      SendFileSamplesWhenFurtherAnalysisIsRequired = { "value" : "[parameters('SendFileSamplesWhenFurtherAnalysisIsRequired')]" }
      AllowIndexingOfEncryptedFiles = { "value" : "[parameters('AllowIndexingOfEncryptedFiles')]" }
      AllowTelemetry = { "value" : "[parameters('AllowTelemetry')]" }
      AllowUnencryptedTraffic = { "value" : "[parameters('AllowUnencryptedTraffic')]" }
      AlwaysInstallWithElevatedPrivileges = { "value" : "[parameters('AlwaysInstallWithElevatedPrivileges')]" }
      AlwaysPromptForPasswordUponConnection = { "value" : "[parameters('AlwaysPromptForPasswordUponConnection')]" }
      ApplicationSpecifyTheMaximumLogFileSizeKB = { "value" : "[parameters('ApplicationSpecifyTheMaximumLogFileSizeKB')]" }
      AutomaticallySendMemoryDumpsForOSgeneratedErrorReports = { "value" : "[parameters('AutomaticallySendMemoryDumpsForOSgeneratedErrorReports')]" }
      ConfigureDefaultConsent = { "value" : "[parameters('ConfigureDefaultConsent')]" }
      ConfigureWindowsSmartScreen = { "value" : "[parameters('ConfigureWindowsSmartScreen')]" }
      DisallowDigestAuthentication = { "value" : "[parameters('DisallowDigestAuthentication')]" }
      DisallowWinRMFromStoringRunAsCredentials = { "value" : "[parameters('DisallowWinRMFromStoringRunAsCredentials')]" }
      DoNotAllowPasswordsToBeSaved = { "value" : "[parameters('DoNotAllowPasswordsToBeSaved')]" }
      SecuritySpecifyTheMaximumLogFileSizeKB = { "value" : "[parameters('SecuritySpecifyTheMaximumLogFileSizeKB')]" }
      SetClientConnectionEncryptionLevel = { "value" : "[parameters('SetClientConnectionEncryptionLevel')]" }
      SetTheDefaultBehaviorForAutoRun = { "value" : "[parameters('SetTheDefaultBehaviorForAutoRun')]" }
      SetupSpecifyTheMaximumLogFileSizeKB = { "value" : "[parameters('SetupSpecifyTheMaximumLogFileSizeKB')]" }
      SystemSpecifyTheMaximumLogFileSizeKB = { "value" : "[parameters('SystemSpecifyTheMaximumLogFileSizeKB')]" }
      TurnOffDataExecutionPreventionForExplorer = { "value" : "[parameters('TurnOffDataExecutionPreventionForExplorer')]" }
      SpecifyTheIntervalToCheckForDefinitionUpdates = { "value" : "[parameters('SpecifyTheIntervalToCheckForDefinitionUpdates')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows machines should meet requirements for 'Windows Firewall Properties'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      WindowsFirewallDomainUseProfileSettings = { "value" : "[parameters('WindowsFirewallDomainUseProfileSettings')]" }
      WindowsFirewallDomainBehaviorForOutboundConnections = { "value" : "[parameters('WindowsFirewallDomainBehaviorForOutboundConnections')]" }
      WindowsFirewallDomainApplyLocalConnectionSecurityRules = { "value" : "[parameters('WindowsFirewallDomainApplyLocalConnectionSecurityRules')]" }
      WindowsFirewallDomainApplyLocalFirewallRules = { "value" : "[parameters('WindowsFirewallDomainApplyLocalFirewallRules')]" }
      WindowsFirewallDomainDisplayNotifications = { "value" : "[parameters('WindowsFirewallDomainDisplayNotifications')]" }
      WindowsFirewallPrivateUseProfileSettings = { "value" : "[parameters('WindowsFirewallPrivateUseProfileSettings')]" }
      WindowsFirewallPrivateBehaviorForOutboundConnections = { "value" : "[parameters('WindowsFirewallPrivateBehaviorForOutboundConnections')]" }
      WindowsFirewallPrivateApplyLocalConnectionSecurityRules = { "value" : "[parameters('WindowsFirewallPrivateApplyLocalConnectionSecurityRules')]" }
      WindowsFirewallPrivateApplyLocalFirewallRules = { "value" : "[parameters('WindowsFirewallPrivateApplyLocalFirewallRules')]" }
      WindowsFirewallPrivateDisplayNotifications = { "value" : "[parameters('WindowsFirewallPrivateDisplayNotifications')]" }
      WindowsFirewallPublicUseProfileSettings = { "value" : "[parameters('WindowsFirewallPublicUseProfileSettings')]" }
      WindowsFirewallPublicBehaviorForOutboundConnections = { "value" : "[parameters('WindowsFirewallPublicBehaviorForOutboundConnections')]" }
      WindowsFirewallPublicApplyLocalConnectionSecurityRules = { "value" : "[parameters('WindowsFirewallPublicApplyLocalConnectionSecurityRules')]" }
      WindowsFirewallPublicApplyLocalFirewallRules = { "value" : "[parameters('WindowsFirewallPublicApplyLocalFirewallRules')]" }
      WindowsFirewallPublicDisplayNotifications = { "value" : "[parameters('WindowsFirewallPublicDisplayNotifications')]" }
      WindowsFirewallDomainAllowUnicastResponse = { "value" : "[parameters('WindowsFirewallDomainAllowUnicastResponse')]" }
      WindowsFirewallPrivateAllowUnicastResponse = { "value" : "[parameters('WindowsFirewallPrivateAllowUnicastResponse')]" }
      WindowsFirewallPublicAllowUnicastResponse = { "value" : "[parameters('WindowsFirewallPublicAllowUnicastResponse')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Windows web servers should be configured to use secure communication protocols")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      MinimumTLSVersion = { "value" : "[parameters('MinimumTLSVersion')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Linux machines should meet requirements for the Azure security baseline")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Windows machines should meet requirements of the Azure Security Center baseline")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
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
    "IncludeArcMachines": {
        "name": "IncludeArcMachines",
        "type": "string",
        "description": "By selecting this option, you agree to be charged monthly per Arc connected machine.",
        "display_name": "Include Arc connected servers",
        "default_value": "false",
        "allowed_values": [
            "true",
            "false"
        ]
    },
    "EMSPortNumber": {
        "name": "EMSPortNumber",
        "type": "string",
        "description": "An integer indicating the COM port to be used for the Emergency Management Services (EMS) console redirection. For more information on EMS settings, please visit https://aka.ms/gcpolwsc",
        "display_name": "EMS Port Number",
        "default_value": "1",
        "allowed_values": [
            "1",
            "2",
            "3",
            "4"
        ]
    },
    "EMSBaudRate": {
        "name": "EMSBaudRate",
        "type": "string",
        "description": "An integer indicating the baud rate to be used for the Emergency Management Services (EMS) console redirection. For more information on EMS settings, please visit https://aka.ms/gcpolwsc",
        "display_name": "EMS Baud Rate",
        "default_value": "115200",
        "allowed_values": [
            "9600",
            "19200",
            "38400",
            "57600",
            "115200"
        ]
    },
    "Members": {
        "name": "Members",
        "type": "string",
        "description": "A semicolon-separated list of all the expected members of the Administrators local group. Ex: Administrator; myUser1; myUser2",
        "display_name": "Members",
        "default_value": "Administrator"
    },
    "NumberOfDays": {
        "name": "NumberOfDays",
        "type": "string",
        "description": "The number of days without restart until the machine is considered non-compliant",
        "display_name": "Number of days",
        "default_value": "12"
    },
    "NotAvailableMachineState": {
        "name": "NotAvailableMachineState",
        "type": "string",
        "description": "Windows Defender Exploit Guard is only available starting with Windows 10/Windows Server with update 1709. Setting this value to 'Non-Compliant' shows machines with older versions on which Windows Defender Exploit Guard is not available (such as Windows Server 2012 R2) as non-compliant. Setting this value to 'Compliant' shows these machines as compliant.",
        "display_name": "Status if Windows Defender is not available on machine",
        "default_value": "Compliant",
        "allowed_values": [
            "Compliant",
            "Non-Compliant"
        ]
    },
    "EnableInsecureGuestLogons": {
        "name": "EnableInsecureGuestLogons",
        "type": "string",
        "description": "Specifies whether the SMB client will allow insecure guest logons to an SMB server.",
        "display_name": "Enable insecure guest logons",
        "default_value": "0"
    },
    "AllowSimultaneousConnectionsToTheInternetOrAWindowsDomain": {
        "name": "AllowSimultaneousConnectionsToTheInternetOrAWindowsDomain",
        "type": "string",
        "description": "Specify whether to prevent computers from connecting to both a domain based network and a non-domain based network at the same time. A value of 0 allows simultaneous connections, and a value of 1 blocks them.",
        "display_name": "Allow simultaneous connections to the Internet or a Windows Domain",
        "default_value": "1"
    },
    "TurnOffMulticastNameResolution": {
        "name": "TurnOffMulticastNameResolution",
        "type": "string",
        "description": "Specifies whether LLMNR, a secondary name resolution protocol that transmits using multicast over a local subnet link on a single subnet, is enabled.",
        "display_name": "Turn off multicast name resolution",
        "default_value": "1"
    },
    "AlwaysUseClassicLogon": {
        "name": "AlwaysUseClassicLogon",
        "type": "string",
        "description": "Specifies whether to force the user to log on to the computer using the classic logon screen. This setting only works when the computer is not on a domain.",
        "display_name": "Always use classic logon",
        "default_value": "0"
    },
    "BootStartDriverInitializationPolicy": {
        "name": "BootStartDriverInitializationPolicy",
        "type": "string",
        "description": "Specifies which boot-start drivers are initialized based on a classification determined by an Early Launch Antimalware boot-start driver.",
        "display_name": "Boot-Start Driver Initialization Policy",
        "default_value": "3"
    },
    "EnableWindowsNTPClient": {
        "name": "EnableWindowsNTPClient",
        "type": "string",
        "description": "Specifies whether the Windows NTP Client is enabled. Enabling the Windows NTP Client allows your computer to synchronize its computer clock with other NTP servers.",
        "display_name": "Enable Windows NTP Client",
        "default_value": "1"
    },
    "TurnOnConveniencePINSignin": {
        "name": "TurnOnConveniencePINSignin",
        "type": "string",
        "description": "Specifies whether a domain user can sign in using a convenience PIN.",
        "display_name": "Turn on convenience PIN sign-in",
        "default_value": "0"
    },
    "AccountsGuestAccountStatus": {
        "name": "AccountsGuestAccountStatus",
        "type": "string",
        "description": "Specifies whether the local Guest account is disabled.",
        "display_name": "Accounts: Guest account status",
        "default_value": "0"
    },
    "AuditShutDownSystemImmediatelyIfUnableToLogSecurityAudits": {
        "name": "AuditShutDownSystemImmediatelyIfUnableToLogSecurityAudits",
        "type": "string",
        "description": "Audits if the system will shut down when unable to log Security events.",
        "display_name": "Audit: Shut down system immediately if unable to log security audits",
        "default_value": "0"
    },
    "DevicesAllowedToFormatAndEjectRemovableMedia": {
        "name": "DevicesAllowedToFormatAndEjectRemovableMedia",
        "type": "string",
        "description": "Specifies who is allowed to format and eject removable NTFS media. You can use this policy setting to prevent unauthorized users from removing data on one computer to access it on another computer on which they have local administrator privileges.",
        "display_name": "Devices: Allowed to format and eject removable media",
        "default_value": "0"
    },
    "MicrosoftNetworkClientDigitallySignCommunicationsAlways": {
        "name": "MicrosoftNetworkClientDigitallySignCommunicationsAlways",
        "type": "string",
        "description": "Specifies whether packet signing is required by the SMB client component.",
        "display_name": "Microsoft network client: Digitally sign communications (always)",
        "default_value": "1"
    },
    "MicrosoftNetworkClientSendUnencryptedPasswordToThirdpartySMBServers": {
        "name": "MicrosoftNetworkClientSendUnencryptedPasswordToThirdpartySMBServers",
        "type": "string",
        "description": "Specifies whether the SMB redirector will send plaintext passwords during authentication to third-party SMB servers that do not support password encryption. It is recommended that you disable this policy setting unless there is a strong business case to enable it.",
        "display_name": "Microsoft network client: Send unencrypted password to third-party SMB servers",
        "default_value": "0"
    },
    "MicrosoftNetworkServerAmountOfIdleTimeRequiredBeforeSuspendingSession": {
        "name": "MicrosoftNetworkServerAmountOfIdleTimeRequiredBeforeSuspendingSession",
        "type": "string",
        "description": "Specifies the amount of continuous idle time that must pass in an SMB session before the session is suspended because of inactivity. The format of the value is two integers separated by a comma, denoting an inclusive range.",
        "display_name": "Microsoft network server: Amount of idle time required before suspending session",
        "default_value": "1,15"
    },
    "MicrosoftNetworkServerDigitallySignCommunicationsAlways": {
        "name": "MicrosoftNetworkServerDigitallySignCommunicationsAlways",
        "type": "string",
        "description": "Specifies whether packet signing is required by the SMB server component.",
        "display_name": "Microsoft network server: Digitally sign communications (always)",
        "default_value": "1"
    },
    "MicrosoftNetworkServerDisconnectClientsWhenLogonHoursExpire": {
        "name": "MicrosoftNetworkServerDisconnectClientsWhenLogonHoursExpire",
        "type": "string",
        "description": "Specifies whether to disconnect users who are connected to the local computer outside their user account's valid logon hours. This setting affects the Server Message Block (SMB) component. If you enable this policy setting you should also enable 'Network security: Force logoff when logon hours expire'",
        "display_name": "Microsoft network server: Disconnect clients when logon hours expire",
        "default_value": "1"
    },
    "NetworkAccessRemotelyAccessibleRegistryPaths": {
        "name": "NetworkAccessRemotelyAccessibleRegistryPaths",
        "type": "string",
        "description": "Specifies which registry paths will be accessible over the network, regardless of the users or groups listed in the access control list (ACL) of the `winreg` registry key.",
        "display_name": "Network access: Remotely accessible registry paths",
        "default_value": "System\\CurrentControlSet\\Control\\ProductOptions|#|System\\CurrentControlSet\\Control\\Server Applications|#|Software\\Microsoft\\Windows NT\\CurrentVersion"
    },
    "NetworkAccessRemotelyAccessibleRegistryPathsAndSubpaths": {
        "name": "NetworkAccessRemotelyAccessibleRegistryPathsAndSubpaths",
        "type": "string",
        "description": "Specifies which registry paths and sub-paths will be accessible over the network, regardless of the users or groups listed in the access control list (ACL) of the `winreg` registry key.",
        "display_name": "Network access: Remotely accessible registry paths and sub-paths",
        "default_value": "System\\CurrentControlSet\\Control\\Print\\Printers|#|System\\CurrentControlSet\\Services\\Eventlog|#|Software\\Microsoft\\OLAP Server|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Print|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows|#|System\\CurrentControlSet\\Control\\ContentIndex|#|System\\CurrentControlSet\\Control\\Terminal Server|#|System\\CurrentControlSet\\Control\\Terminal Server\\UserConfig|#|System\\CurrentControlSet\\Control\\Terminal Server\\DefaultUserConfiguration|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Perflib|#|System\\CurrentControlSet\\Services\\SysmonLog"
    },
    "NetworkAccessSharesThatCanBeAccessedAnonymously": {
        "name": "NetworkAccessSharesThatCanBeAccessedAnonymously",
        "type": "string",
        "description": "Specifies which network shares can be accessed by anonymous users. The default configuration for this policy setting has little effect because all users have to be authenticated before they can access shared resources on the server.",
        "display_name": "Network access: Shares that can be accessed anonymously",
        "default_value": "0"
    },
    "NetworkSecurityConfigureEncryptionTypesAllowedForKerberos": {
        "name": "NetworkSecurityConfigureEncryptionTypesAllowedForKerberos",
        "type": "string",
        "description": "Specifies the encryption types that Kerberos is allowed to use.",
        "display_name": "Network Security: Configure encryption types allowed for Kerberos",
        "default_value": "2147483644"
    },
    "NetworkSecurityLANManagerAuthenticationLevel": {
        "name": "NetworkSecurityLANManagerAuthenticationLevel",
        "type": "string",
        "description": "Specify which challenge-response authentication protocol is used for network logons. This choice affects the level of authentication protocol used by clients, the level of session security negotiated, and the level of authentication accepted by servers.",
        "display_name": "Network security: LAN Manager authentication level",
        "default_value": "5"
    },
    "NetworkSecurityLDAPClientSigningRequirements": {
        "name": "NetworkSecurityLDAPClientSigningRequirements",
        "type": "string",
        "description": "Specify the level of data signing that is requested on behalf of clients that issue LDAP BIND requests.",
        "display_name": "Network security: LDAP client signing requirements",
        "default_value": "1"
    },
    "NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCClients": {
        "name": "NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCClients",
        "type": "string",
        "description": "Specifies which behaviors are allowed by clients for applications using the NTLM Security Support Provider (SSP). The SSP Interface (SSPI) is used by applications that need authentication services. See https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/network-security-minimum-session-security-for-ntlm-ssp-based-including-secure-rpc-servers for more information.",
        "display_name": "Network security: Minimum session security for NTLM SSP based (including secure RPC) clients",
        "default_value": "537395200"
    },
    "NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCServers": {
        "name": "NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCServers",
        "type": "string",
        "description": "Specifies which behaviors are allowed by servers for applications using the NTLM Security Support Provider (SSP). The SSP Interface (SSPI) is used by applications that need authentication services.",
        "display_name": "Network security: Minimum session security for NTLM SSP based (including secure RPC) servers",
        "default_value": "537395200"
    },
    "RecoveryConsoleAllowFloppyCopyAndAccessToAllDrivesAndAllFolders": {
        "name": "RecoveryConsoleAllowFloppyCopyAndAccessToAllDrivesAndAllFolders",
        "type": "string",
        "description": "Specifies whether to make the Recovery Console SET command available, which allows setting of recovery console environment variables.",
        "display_name": "Recovery console: Allow floppy copy and access to all drives and all folders",
        "default_value": "0"
    },
    "ShutdownAllowSystemToBeShutDownWithoutHavingToLogOn": {
        "name": "ShutdownAllowSystemToBeShutDownWithoutHavingToLogOn",
        "type": "string",
        "description": "Specifies whether a computer can be shut down when a user is not logged on. If this policy setting is enabled, the shutdown command is available on the Windows logon screen.",
        "display_name": "Shutdown: Allow system to be shut down without having to log on",
        "default_value": "0"
    },
    "ShutdownClearVirtualMemoryPagefile": {
        "name": "ShutdownClearVirtualMemoryPagefile",
        "type": "string",
        "description": "Specifies whether the virtual memory pagefile is cleared when the system is shut down. When this policy setting is enabled, the system pagefile is cleared each time that the system shuts down properly. For systems with large amounts of RAM, this could result in substantial time needed to complete the shutdown.",
        "display_name": "Shutdown: Clear virtual memory pagefile",
        "default_value": "0"
    },
    "SystemSettingsUseCertificateRulesOnWindowsExecutablesForSoftwareRestrictionPolicies": {
        "name": "SystemSettingsUseCertificateRulesOnWindowsExecutablesForSoftwareRestrictionPolicies",
        "type": "string",
        "description": "Specifies whether digital certificates are processed when software restriction policies are enabled and a user or process attempts to run software with an .exe file name extension. It enables or disables certificate rules (a type of software restriction policies rule). For certificate rules to take effect in software restriction policies, you must enable this policy setting.",
        "display_name": "System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies",
        "default_value": "1"
    },
    "UACAdminApprovalModeForTheBuiltinAdministratorAccount": {
        "name": "UACAdminApprovalModeForTheBuiltinAdministratorAccount",
        "type": "string",
        "description": "Specifies the behavior of Admin Approval Mode for the built-in Administrator account.",
        "display_name": "UAC: Admin Approval Mode for the Built-in Administrator account",
        "default_value": "1"
    },
    "UACBehaviorOfTheElevationPromptForAdministratorsInAdminApprovalMode": {
        "name": "UACBehaviorOfTheElevationPromptForAdministratorsInAdminApprovalMode",
        "type": "string",
        "description": "Specifies the behavior of the elevation prompt for administrators.",
        "display_name": "UAC: Behavior of the elevation prompt for administrators in Admin Approval Mode",
        "default_value": "2"
    },
    "UACDetectApplicationInstallationsAndPromptForElevation": {
        "name": "UACDetectApplicationInstallationsAndPromptForElevation",
        "type": "string",
        "description": "Specifies the behavior of application installation detection for the computer.",
        "display_name": "UAC: Detect application installations and prompt for elevation",
        "default_value": "1"
    },
    "UACRunAllAdministratorsInAdminApprovalMode": {
        "name": "UACRunAllAdministratorsInAdminApprovalMode",
        "type": "string",
        "description": "Specifies the behavior of all User Account Control (UAC) policy settings for the computer.",
        "display_name": "UAC: Run all administrators in Admin Approval Mode",
        "default_value": "1"
    },
    "EnforcePasswordHistory": {
        "name": "EnforcePasswordHistory",
        "type": "string",
        "description": "Specifies limits on password reuse - how many times a new password must be created for a user account before the password can be repeated.",
        "display_name": "Enforce password history",
        "default_value": "24"
    },
    "MaximumPasswordAge": {
        "name": "MaximumPasswordAge",
        "type": "string",
        "description": "Specifies the maximum number of days that may elapse before a user account password must be changed. The format of the value is two integers separated by a comma, denoting an inclusive range.",
        "display_name": "Maximum password age",
        "default_value": "1,70"
    },
    "MinimumPasswordAge": {
        "name": "MinimumPasswordAge",
        "type": "string",
        "description": "Specifies the minimum number of days that must elapse before a user account password can be changed.",
        "display_name": "Minimum password age",
        "default_value": "1"
    },
    "MinimumPasswordLength": {
        "name": "MinimumPasswordLength",
        "type": "string",
        "description": "Specifies the minimum number of characters that a user account password may contain.",
        "display_name": "Minimum password length",
        "default_value": "14"
    },
    "PasswordMustMeetComplexityRequirements": {
        "name": "PasswordMustMeetComplexityRequirements",
        "type": "string",
        "description": "Specifies whether a user account password must be complex. If required, a complex password must not contain part of  user's account name or full name; be at least 6 characters long; contain a mix of uppercase, lowercase, number, and non-alphabetic characters.",
        "display_name": "Password must meet complexity requirements",
        "default_value": "1"
    },
    "AuditCredentialValidation": {
        "name": "AuditCredentialValidation",
        "type": "string",
        "description": "Specifies whether audit events are generated when credentials are submitted for a user account logon request.  This setting is especially useful for monitoring unsuccessful attempts, to find brute-force attacks, account enumeration, and potential account compromise events on domain controllers.",
        "display_name": "Audit Credential Validation",
        "default_value": "Success and Failure",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditProcessTermination": {
        "name": "AuditProcessTermination",
        "type": "string",
        "description": "Specifies whether audit events are generated when a process has exited. Recommended for monitoring termination of critical processes.",
        "display_name": "Audit Process Termination",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditGroupMembership": {
        "name": "AuditGroupMembership",
        "type": "string",
        "description": "Specifies whether audit events are generated when group memberships are enumerated on the client computer.",
        "display_name": "Audit Group Membership",
        "default_value": "Success",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditDetailedFileShare": {
        "name": "AuditDetailedFileShare",
        "type": "string",
        "description": "If this policy setting is enabled, access to all shared files and folders on the system is audited. Auditing for Success can lead to very high volumes of events.",
        "display_name": "Audit Detailed File Share",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditFileShare": {
        "name": "AuditFileShare",
        "type": "string",
        "description": "Specifies whether to audit events related to file shares: creation, deletion, modification, and access attempts. Also, it shows failed SMB SPN checks. Event volumes can be high on DCs and File Servers.",
        "display_name": "Audit File Share",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditFileSystem": {
        "name": "AuditFileSystem",
        "type": "string",
        "description": "Specifies whether audit events are generated when users attempt to access file system objects. Audit events are generated only for objects that have configured system access control lists (SACLs).",
        "display_name": "Audit File System",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditAuthenticationPolicyChange": {
        "name": "AuditAuthenticationPolicyChange",
        "type": "string",
        "description": "Specifies whether audit events are generated when changes are made to authentication policy. This setting is useful for tracking changes in domain-level and forest-level trust and privileges that are granted to user accounts or groups.",
        "display_name": "Audit Authentication Policy Change",
        "default_value": "Success",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditAuthorizationPolicyChange": {
        "name": "AuditAuthorizationPolicyChange",
        "type": "string",
        "description": "Specifies whether audit events are generated for assignment and removal of user rights in user right policies, changes in security token object permission, resource attributes changes and Central Access Policy changes for file system objects.",
        "display_name": "Audit Authorization Policy Change",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "AuditOtherSystemEvents": {
        "name": "AuditOtherSystemEvents",
        "type": "string",
        "description": "Specifies whether audit events are generated for Windows Firewall Service and Windows Firewall driver start and stop events, failure events for these services and Windows Firewall Service policy processing failures.",
        "display_name": "Audit Other System Events",
        "default_value": "No Auditing",
        "allowed_values": [
            "No Auditing",
            "Success",
            "Failure",
            "Success and Failure"
        ]
    },
    "UsersOrGroupsThatMayAccessThisComputerFromTheNetwork": {
        "name": "UsersOrGroupsThatMayAccessThisComputerFromTheNetwork",
        "type": "string",
        "description": "Specifies which remote users on the network are permitted to connect to the computer. This does not include Remote Desktop Connection.",
        "display_name": "Users or groups that may access this computer from the network",
        "default_value": "Administrators, Authenticated Users"
    },
    "UsersOrGroupsThatMayLogOnLocally": {
        "name": "UsersOrGroupsThatMayLogOnLocally",
        "type": "string",
        "description": "Specifies which users or groups can interactively log on to the computer. Users who attempt to log on via Remote Desktop Connection or IIS also require this user right.",
        "display_name": "Users or groups that may log on locally",
        "default_value": "Administrators"
    },
    "UsersOrGroupsThatMayLogOnThroughRemoteDesktopServices": {
        "name": "UsersOrGroupsThatMayLogOnThroughRemoteDesktopServices",
        "type": "string",
        "description": "Specifies which users or groups are permitted to log on as a Terminal Services client, Remote Desktop, or for Remote Assistance.",
        "display_name": "Users or groups that may log on through Remote Desktop Services",
        "default_value": "Administrators, Remote Desktop Users"
    },
    "UsersAndGroupsThatAreDeniedAccessToThisComputerFromTheNetwork": {
        "name": "UsersAndGroupsThatAreDeniedAccessToThisComputerFromTheNetwork",
        "type": "string",
        "description": "Specifies which users or groups are explicitly prohibited from connecting to the computer across the network.",
        "display_name": "Users and groups that are denied access to this computer from the network",
        "default_value": "Guests"
    },
    "UsersOrGroupsThatMayManageAuditingAndSecurityLog": {
        "name": "UsersOrGroupsThatMayManageAuditingAndSecurityLog",
        "type": "string",
        "description": "Specifies users and groups permitted to change the auditing options for files and directories and clear the Security log.",
        "display_name": "Users or groups that may manage auditing and security log",
        "default_value": "Administrators"
    },
    "UsersOrGroupsThatMayBackUpFilesAndDirectories": {
        "name": "UsersOrGroupsThatMayBackUpFilesAndDirectories",
        "type": "string",
        "description": "Specifies users and groups allowed to circumvent file and directory permissions to back up the system.",
        "display_name": "Users or groups that may back up files and directories",
        "default_value": "Administrators, Backup Operators"
    },
    "UsersOrGroupsThatMayChangeTheSystemTime": {
        "name": "UsersOrGroupsThatMayChangeTheSystemTime",
        "type": "string",
        "description": "Specifies which users and groups are permitted to change the time and date on the internal clock of the computer.",
        "display_name": "Users or groups that may change the system time",
        "default_value": "Administrators, LOCAL SERVICE"
    },
    "UsersOrGroupsThatMayChangeTheTimeZone": {
        "name": "UsersOrGroupsThatMayChangeTheTimeZone",
        "type": "string",
        "description": "Specifies which users and groups are permitted to change the time zone of the computer.",
        "display_name": "Users or groups that may change the time zone",
        "default_value": "Administrators, LOCAL SERVICE"
    },
    "UsersOrGroupsThatMayCreateATokenObject": {
        "name": "UsersOrGroupsThatMayCreateATokenObject",
        "type": "string",
        "description": "Specifies which users and groups are permitted to create an access token, which may provide elevated rights to access sensitive data.",
        "display_name": "Users or groups that may create a token object",
        "default_value": "No One"
    },
    "UsersAndGroupsThatAreDeniedLoggingOnAsABatchJob": {
        "name": "UsersAndGroupsThatAreDeniedLoggingOnAsABatchJob",
        "type": "string",
        "description": "Specifies which users and groups are explicitly not permitted to log on to the computer as a batch job (i.e. scheduled task).",
        "display_name": "Users and groups that are denied logging on as a batch job",
        "default_value": "Guests"
    },
    "UsersAndGroupsThatAreDeniedLoggingOnAsAService": {
        "name": "UsersAndGroupsThatAreDeniedLoggingOnAsAService",
        "type": "string",
        "description": "Specifies which service accounts are explicitly not permitted to register a process as a service.",
        "display_name": "Users and groups that are denied logging on as a service",
        "default_value": "Guests"
    },
    "UsersAndGroupsThatAreDeniedLocalLogon": {
        "name": "UsersAndGroupsThatAreDeniedLocalLogon",
        "type": "string",
        "description": "Specifies which users and groups are explicitly not permitted to log on to the computer.",
        "display_name": "Users and groups that are denied local logon",
        "default_value": "Guests"
    },
    "UsersAndGroupsThatAreDeniedLogOnThroughRemoteDesktopServices": {
        "name": "UsersAndGroupsThatAreDeniedLogOnThroughRemoteDesktopServices",
        "type": "string",
        "description": "Specifies which users and groups are explicitly not permitted to log on to the computer via Terminal Services/Remote Desktop Client.",
        "display_name": "Users and groups that are denied log on through Remote Desktop Services",
        "default_value": "Guests"
    },
    "UserAndGroupsThatMayForceShutdownFromARemoteSystem": {
        "name": "UserAndGroupsThatMayForceShutdownFromARemoteSystem",
        "type": "string",
        "description": "Specifies which users and groups are permitted to shut down the computer from a remote location on the network.",
        "display_name": "User and groups that may force shutdown from a remote system",
        "default_value": "Administrators"
    },
    "UsersAndGroupsThatMayRestoreFilesAndDirectories": {
        "name": "UsersAndGroupsThatMayRestoreFilesAndDirectories",
        "type": "string",
        "description": "Specifies which users and groups are permitted to bypass file, directory, registry, and other persistent object permissions when restoring backed up files and directories.",
        "display_name": "Users and groups that may restore files and directories",
        "default_value": "Administrators, Backup Operators"
    },
    "UsersAndGroupsThatMayShutDownTheSystem": {
        "name": "UsersAndGroupsThatMayShutDownTheSystem",
        "type": "string",
        "description": "Specifies which users and groups who are logged on locally to the computers in your environment are permitted to shut down the operating system with the Shut Down command.",
        "display_name": "Users and groups that may shut down the system",
        "default_value": "Administrators"
    },
    "UsersOrGroupsThatMayTakeOwnershipOfFilesOrOtherObjects": {
        "name": "UsersOrGroupsThatMayTakeOwnershipOfFilesOrOtherObjects",
        "type": "string",
        "description": "Specifies which users and groups are permitted to take ownership of files, folders, registry keys, processes, or threads. This user right bypasses any permissions that are in place to protect objects to give ownership to the specified user.",
        "display_name": "Users or groups that may take ownership of files or other objects",
        "default_value": "Administrators"
    },
    "SendFileSamplesWhenFurtherAnalysisIsRequired": {
        "name": "SendFileSamplesWhenFurtherAnalysisIsRequired",
        "type": "string",
        "description": "Specifies whether and how Windows Defender will submit samples of suspected malware  to Microsoft for further analysis when opt-in for MAPS telemetry is set.",
        "display_name": "Send file samples when further analysis is required",
        "default_value": "1"
    },
    "AllowIndexingOfEncryptedFiles": {
        "name": "AllowIndexingOfEncryptedFiles",
        "type": "string",
        "description": "Specifies whether encrypted items are allowed to be indexed.",
        "display_name": "Allow indexing of encrypted files",
        "default_value": "0"
    },
    "AllowTelemetry": {
        "name": "AllowTelemetry",
        "type": "string",
        "description": "Specifies configuration of the amount of diagnostic and usage data reported to Microsoft. The data is transmitted securely and sensitive data is not sent.",
        "display_name": "Allow Telemetry",
        "default_value": "2"
    },
    "AllowUnencryptedTraffic": {
        "name": "AllowUnencryptedTraffic",
        "type": "string",
        "description": "Specifies whether the Windows Remote Management (WinRM) service sends and receives unencrypted messages over the network.",
        "display_name": "Allow unencrypted traffic",
        "default_value": "0"
    },
    "AlwaysInstallWithElevatedPrivileges": {
        "name": "AlwaysInstallWithElevatedPrivileges",
        "type": "string",
        "description": "Specifies whether Windows Installer should use system permissions when it installs any program on the system.",
        "display_name": "Always install with elevated privileges",
        "default_value": "0"
    },
    "AlwaysPromptForPasswordUponConnection": {
        "name": "AlwaysPromptForPasswordUponConnection",
        "type": "string",
        "description": "Specifies whether Terminal Services/Remote Desktop Connection always prompts the client computer for a password upon connection.",
        "display_name": "Always prompt for password upon connection",
        "default_value": "1"
    },
    "ApplicationSpecifyTheMaximumLogFileSizeKB": {
        "name": "ApplicationSpecifyTheMaximumLogFileSizeKB",
        "type": "string",
        "description": "Specifies the maximum size for the Application event log in kilobytes.",
        "display_name": "Application: Specify the maximum log file size (KB)",
        "default_value": "32768"
    },
    "AutomaticallySendMemoryDumpsForOSgeneratedErrorReports": {
        "name": "AutomaticallySendMemoryDumpsForOSgeneratedErrorReports",
        "type": "string",
        "description": "Specifies if memory dumps in support of OS-generated error reports can be sent to Microsoft automatically.",
        "display_name": "Automatically send memory dumps for OS-generated error reports",
        "default_value": "1"
    },
    "ConfigureDefaultConsent": {
        "name": "ConfigureDefaultConsent",
        "type": "string",
        "description": "Specifies setting of the default consent handling for error reports sent to Microsoft.",
        "display_name": "Configure Default consent",
        "default_value": "4"
    },
    "ConfigureWindowsSmartScreen": {
        "name": "ConfigureWindowsSmartScreen",
        "type": "string",
        "description": "Specifies how to manage the behavior of Windows SmartScreen. Windows SmartScreen helps keep PCs safer by warning users before running unrecognized programs downloaded from the Internet. Some information is sent to Microsoft about files and programs run on PCs with this feature enabled.",
        "display_name": "Configure Windows SmartScreen",
        "default_value": "1"
    },
    "DisallowDigestAuthentication": {
        "name": "DisallowDigestAuthentication",
        "type": "string",
        "description": "Specifies whether the Windows Remote Management (WinRM) client will not use Digest authentication.",
        "display_name": "Disallow Digest authentication",
        "default_value": "0"
    },
    "DisallowWinRMFromStoringRunAsCredentials": {
        "name": "DisallowWinRMFromStoringRunAsCredentials",
        "type": "string",
        "description": "Specifies whether the Windows Remote Management (WinRM) service will not allow RunAs credentials to be stored for any plug-ins.",
        "display_name": "Disallow WinRM from storing RunAs credentials",
        "default_value": "1"
    },
    "DoNotAllowPasswordsToBeSaved": {
        "name": "DoNotAllowPasswordsToBeSaved",
        "type": "string",
        "description": "Specifies whether to prevent Remote Desktop Services - Terminal Services clients from saving passwords on a computer.",
        "display_name": "Do not allow passwords to be saved",
        "default_value": "1"
    },
    "SecuritySpecifyTheMaximumLogFileSizeKB": {
        "name": "SecuritySpecifyTheMaximumLogFileSizeKB",
        "type": "string",
        "description": "Specifies the maximum size for the Security event log in kilobytes.",
        "display_name": "Security: Specify the maximum log file size (KB)",
        "default_value": "196608"
    },
    "SetClientConnectionEncryptionLevel": {
        "name": "SetClientConnectionEncryptionLevel",
        "type": "string",
        "description": "Specifies whether to require the use of a specific encryption level to secure communications between client computers and RD Session Host servers during Remote Desktop Protocol (RDP) connections. This policy only applies when you are using native RDP encryption.",
        "display_name": "Set client connection encryption level",
        "default_value": "3"
    },
    "SetTheDefaultBehaviorForAutoRun": {
        "name": "SetTheDefaultBehaviorForAutoRun",
        "type": "string",
        "description": "Specifies the default behavior for Autorun commands. Autorun commands are generally stored in autorun.inf files. They often launch the installation program or other routines.",
        "display_name": "Set the default behavior for AutoRun",
        "default_value": "1"
    },
    "SetupSpecifyTheMaximumLogFileSizeKB": {
        "name": "SetupSpecifyTheMaximumLogFileSizeKB",
        "type": "string",
        "description": "Specifies the maximum size for the Setup event log in kilobytes.",
        "display_name": "Setup: Specify the maximum log file size (KB)",
        "default_value": "32768"
    },
    "SystemSpecifyTheMaximumLogFileSizeKB": {
        "name": "SystemSpecifyTheMaximumLogFileSizeKB",
        "type": "string",
        "description": "Specifies the maximum size for the System event log in kilobytes.",
        "display_name": "System: Specify the maximum log file size (KB)",
        "default_value": "32768"
    },
    "TurnOffDataExecutionPreventionForExplorer": {
        "name": "TurnOffDataExecutionPreventionForExplorer",
        "type": "string",
        "description": "Specifies whether to turn off Data Execution Prevention for Windows File Explorer. Disabling data execution prevention can allow certain legacy plug-in applications to function without terminating Explorer.",
        "display_name": "Turn off Data Execution Prevention for Explorer",
        "default_value": "0"
    },
    "SpecifyTheIntervalToCheckForDefinitionUpdates": {
        "name": "SpecifyTheIntervalToCheckForDefinitionUpdates",
        "type": "string",
        "description": "Specifies an interval at which to check for Windows Defender definition updates. The time value is represented as the number of hours between update checks.",
        "display_name": "Specify the interval to check for definition updates",
        "default_value": "8"
    },
    "WindowsFirewallDomainUseProfileSettings": {
        "name": "WindowsFirewallDomainUseProfileSettings",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security uses the settings for the Domain profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile.",
        "display_name": "Windows Firewall (Domain): Use profile settings",
        "default_value": "1"
    },
    "WindowsFirewallDomainBehaviorForOutboundConnections": {
        "name": "WindowsFirewallDomainBehaviorForOutboundConnections",
        "type": "string",
        "description": "Specifies the behavior for outbound connections for the Domain profile that do not match an outbound firewall rule. The default value of 0 means to allow connections, and a value of 1 means to block connections.",
        "display_name": "Windows Firewall (Domain): Behavior for outbound connections",
        "default_value": "0"
    },
    "WindowsFirewallDomainApplyLocalConnectionSecurityRules": {
        "name": "WindowsFirewallDomainApplyLocalConnectionSecurityRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create connection security rules that apply together with connection security rules configured by Group Policy for the Domain profile.",
        "display_name": "Windows Firewall (Domain): Apply local connection security rules",
        "default_value": "1"
    },
    "WindowsFirewallDomainApplyLocalFirewallRules": {
        "name": "WindowsFirewallDomainApplyLocalFirewallRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy for the Domain profile.",
        "display_name": "Windows Firewall (Domain): Apply local firewall rules",
        "default_value": "1"
    },
    "WindowsFirewallDomainDisplayNotifications": {
        "name": "WindowsFirewallDomainDisplayNotifications",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security displays notifications to the user when a program is blocked from receiving inbound connections, for the Domain profile.",
        "display_name": "Windows Firewall (Domain): Display notifications",
        "default_value": "1"
    },
    "WindowsFirewallPrivateUseProfileSettings": {
        "name": "WindowsFirewallPrivateUseProfileSettings",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security uses the settings for the Private profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile.",
        "display_name": "Windows Firewall (Private): Use profile settings",
        "default_value": "1"
    },
    "WindowsFirewallPrivateBehaviorForOutboundConnections": {
        "name": "WindowsFirewallPrivateBehaviorForOutboundConnections",
        "type": "string",
        "description": "Specifies the behavior for outbound connections for the Private profile that do not match an outbound firewall rule. The default value of 0 means to allow connections, and a value of 1 means to block connections.",
        "display_name": "Windows Firewall (Private): Behavior for outbound connections",
        "default_value": "0"
    },
    "WindowsFirewallPrivateApplyLocalConnectionSecurityRules": {
        "name": "WindowsFirewallPrivateApplyLocalConnectionSecurityRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create connection security rules that apply together with connection security rules configured by Group Policy for the Private profile.",
        "display_name": "Windows Firewall (Private): Apply local connection security rules",
        "default_value": "1"
    },
    "WindowsFirewallPrivateApplyLocalFirewallRules": {
        "name": "WindowsFirewallPrivateApplyLocalFirewallRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy for the Private profile.",
        "display_name": "Windows Firewall (Private): Apply local firewall rules",
        "default_value": "1"
    },
    "WindowsFirewallPrivateDisplayNotifications": {
        "name": "WindowsFirewallPrivateDisplayNotifications",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security displays notifications to the user when a program is blocked from receiving inbound connections, for the Private profile.",
        "display_name": "Windows Firewall (Private): Display notifications",
        "default_value": "1"
    },
    "WindowsFirewallPublicUseProfileSettings": {
        "name": "WindowsFirewallPublicUseProfileSettings",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security uses the settings for the Public profile to filter network traffic. If you select Off, Windows Firewall with Advanced Security will not use any of the firewall rules or connection security rules for this profile.",
        "display_name": "Windows Firewall (Public): Use profile settings",
        "default_value": "1"
    },
    "WindowsFirewallPublicBehaviorForOutboundConnections": {
        "name": "WindowsFirewallPublicBehaviorForOutboundConnections",
        "type": "string",
        "description": "Specifies the behavior for outbound connections for the Public profile that do not match an outbound firewall rule. The default value of 0 means to allow connections, and a value of 1 means to block connections.",
        "display_name": "Windows Firewall (Public): Behavior for outbound connections",
        "default_value": "0"
    },
    "WindowsFirewallPublicApplyLocalConnectionSecurityRules": {
        "name": "WindowsFirewallPublicApplyLocalConnectionSecurityRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create connection security rules that apply together with connection security rules configured by Group Policy for the Public profile.",
        "display_name": "Windows Firewall (Public): Apply local connection security rules",
        "default_value": "1"
    },
    "WindowsFirewallPublicApplyLocalFirewallRules": {
        "name": "WindowsFirewallPublicApplyLocalFirewallRules",
        "type": "string",
        "description": "Specifies whether local administrators are allowed to create local firewall rules that apply together with firewall rules configured by Group Policy for the Public profile.",
        "display_name": "Windows Firewall (Public): Apply local firewall rules",
        "default_value": "1"
    },
    "WindowsFirewallPublicDisplayNotifications": {
        "name": "WindowsFirewallPublicDisplayNotifications",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security displays notifications to the user when a program is blocked from receiving inbound connections, for the Public profile.",
        "display_name": "Windows Firewall (Public): Display notifications",
        "default_value": "1"
    },
    "WindowsFirewallDomainAllowUnicastResponse": {
        "name": "WindowsFirewallDomainAllowUnicastResponse",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security permits the local computer to receive unicast responses to its outgoing multicast or broadcast messages; for the Domain profile.",
        "display_name": "Windows Firewall: Domain: Allow unicast response",
        "default_value": "0"
    },
    "WindowsFirewallPrivateAllowUnicastResponse": {
        "name": "WindowsFirewallPrivateAllowUnicastResponse",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security permits the local computer to receive unicast responses to its outgoing multicast or broadcast messages; for the Private profile.",
        "display_name": "Windows Firewall: Private: Allow unicast response",
        "default_value": "0"
    },
    "WindowsFirewallPublicAllowUnicastResponse": {
        "name": "WindowsFirewallPublicAllowUnicastResponse",
        "type": "string",
        "description": "Specifies whether Windows Firewall with Advanced Security permits the local computer to receive unicast responses to its outgoing multicast or broadcast messages; for the Public profile.",
        "display_name": "Windows Firewall: Public: Allow unicast response",
        "default_value": "1"
    },
    "MinimumTLSVersion": {
        "name": "MinimumTLSVersion",
        "type": "string",
        "description": "The minimum TLS protocol version that should be enabled. Windows web servers with lower TLS versions will be marked as non-compliant.",
        "display_name": "Minimum TLS version",
        "default_value": "1.1",
        "allowed_values": [
            "1.1",
            "1.2"
        ]
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
resource "azurerm_policy_assignment" "example_PO_Audit" {
  name                 = local.name_example_PO_Audit
  policy_definition_id = azurerm_policy_set_definition.example_PO_Audit.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_PO_Audit
  parameters = jsonencode({
    listOfAllowedSKUs = { "value" = ["Developer", "Premium", "Isolated"] }
	JavaLatestVersion = { "value" = "11" }
	PHPLatestVersion = { "value" = "7.3" }
	WindowsPythonLatestVersion = { "value" = "3.6" }
	LinuxPythonLatestVersion = { "value" = "3.9" }
	requiredRetentionDays = { "value" = "365" }
	supportedSKUs = { "value" = ["DataBox", "DataBoxHeavy"] }
	maxCores = { "value" = 32 }
	IncludeArcMachines = { "value" = "false" }
	EMSPortNumber = { "value" = "1" }
	EMSBaudRate = { "value" = "115200" }
	Members = { "value" = "Administrator" }
	NumberOfDays = { "value" = "12" }
	NotAvailableMachineState = { "value" = "Compliant" }
	EnableInsecureGuestLogons = { "value" = "0" }
	AllowSimultaneousConnectionsToTheInternetOrAWindowsDomain = { "value" = "1" }
	TurnOffMulticastNameResolution = { "value" = "1" }
	AlwaysUseClassicLogon = { "value" = "0" }
	BootStartDriverInitializationPolicy = { "value" = "3" }
	EnableWindowsNTPClient = { "value" = "1" }
	TurnOnConveniencePINSignin = { "value" = "0" }
	AccountsGuestAccountStatus = { "value" = "0" }
	AuditShutDownSystemImmediatelyIfUnableToLogSecurityAudits = { "value" = "0" }
	DevicesAllowedToFormatAndEjectRemovableMedia = { "value" = "0" }
	MicrosoftNetworkClientDigitallySignCommunicationsAlways = { "value" = "1" }
	MicrosoftNetworkClientSendUnencryptedPasswordToThirdpartySMBServers = { "value" = "0" }
	MicrosoftNetworkServerAmountOfIdleTimeRequiredBeforeSuspendingSession = { "value" = "1,15" }
	MicrosoftNetworkServerDigitallySignCommunicationsAlways = { "value" = "1" }
	MicrosoftNetworkServerDisconnectClientsWhenLogonHoursExpire = { "value" = "1" }
	NetworkAccessRemotelyAccessibleRegistryPaths = { "value" = "System\\CurrentControlSet\\Control\\ProductOptions|#|System\\CurrentControlSet\\Control\\Server Applications|#|Software\\Microsoft\\Windows NT\\CurrentVersion" }
	NetworkAccessRemotelyAccessibleRegistryPathsAndSubpaths = { "value" = "System\\CurrentControlSet\\Control\\Print\\Printers|#|System\\CurrentControlSet\\Services\\Eventlog|#|Software\\Microsoft\\OLAP Server|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Print|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows|#|System\\CurrentControlSet\\Control\\ContentIndex|#|System\\CurrentControlSet\\Control\\Terminal Server|#|System\\CurrentControlSet\\Control\\Terminal Server\\UserConfig|#|System\\CurrentControlSet\\Control\\Terminal Server\\DefaultUserConfiguration|#|Software\\Microsoft\\Windows NT\\CurrentVersion\\Perflib|#|System\\CurrentControlSet\\Services\\SysmonLog" }
	NetworkAccessSharesThatCanBeAccessedAnonymously = { "value" = "0" }
	NetworkSecurityConfigureEncryptionTypesAllowedForKerberos = { "value" = "2147483644" }
	NetworkSecurityLANManagerAuthenticationLevel = { "value" = "5" }
	NetworkSecurityLDAPClientSigningRequirements = { "value" = "1" }
	NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCClients = { "value" = "537395200" }
	NetworkSecurityMinimumSessionSecurityForNTLMSSPBasedIncludingSecureRPCServers = { "value" = "537395200" }
	RecoveryConsoleAllowFloppyCopyAndAccessToAllDrivesAndAllFolders = { "value" = "0" }
	ShutdownAllowSystemToBeShutDownWithoutHavingToLogOn = { "value" = "0" }
	ShutdownClearVirtualMemoryPagefile = { "value" = "0" }
	SystemSettingsUseCertificateRulesOnWindowsExecutablesForSoftwareRestrictionPolicies = { "value" = "1" }
	UACAdminApprovalModeForTheBuiltinAdministratorAccount = { "value" = "1" }
	UACBehaviorOfTheElevationPromptForAdministratorsInAdminApprovalMode = { "value" = "2" }
	UACDetectApplicationInstallationsAndPromptForElevation = { "value" = "1" }
	UACRunAllAdministratorsInAdminApprovalMode = { "value" = "1" }
	EnforcePasswordHistory = { "value" = "24" }
	MaximumPasswordAge = { "value" = "1,70" }
	MinimumPasswordAge = { "value" = "1" }
	MinimumPasswordLength = { "value" = "14" }
	PasswordMustMeetComplexityRequirements = { "value" = "1" }
	AuditCredentialValidation = { "value" = "Success and Failure" }
	AuditProcessTermination = { "value" = "No Auditing" }
	AuditGroupMembership = { "value" = "Success" }
	AuditDetailedFileShare = { "value" = "No Auditing" }
	AuditFileShare = { "value" = "No Auditing" }
	AuditFileSystem = { "value" = "No Auditing" }
	AuditAuthenticationPolicyChange = { "value" = "Success" }
	AuditAuthorizationPolicyChange = { "value" = "No Auditing" }
	AuditOtherSystemEvents = { "value" = "No Auditing" }
	UsersOrGroupsThatMayAccessThisComputerFromTheNetwork = { "value" = "Administrators, Authenticated Users" }
	UsersOrGroupsThatMayLogOnLocally = { "value" = "Administrators" }
	UsersOrGroupsThatMayLogOnThroughRemoteDesktopServices = { "value" = "Administrators, Remote Desktop Users" }
	UsersAndGroupsThatAreDeniedAccessToThisComputerFromTheNetwork = { "value" = "Guests" }
	UsersOrGroupsThatMayManageAuditingAndSecurityLog = { "value" = "Administrators" }
	UsersOrGroupsThatMayBackUpFilesAndDirectories = { "value" = "Administrators, Backup Operators" }
	UsersOrGroupsThatMayChangeTheSystemTime = { "value" = "Administrators, LOCAL SERVICE" }
	UsersOrGroupsThatMayChangeTheTimeZone = { "value" = "Administrators, LOCAL SERVICE" }
	UsersOrGroupsThatMayCreateATokenObject = { "value" = "No One" }
	UsersAndGroupsThatAreDeniedLoggingOnAsABatchJob = { "value" = "Guests" }
	UsersAndGroupsThatAreDeniedLoggingOnAsAService = { "value" = "Guests" }
	UsersAndGroupsThatAreDeniedLocalLogon = { "value" = "Guests" }
	UsersAndGroupsThatAreDeniedLogOnThroughRemoteDesktopServices = { "value" = "Guests" }
	UserAndGroupsThatMayForceShutdownFromARemoteSystem = { "value" = "Administrators" }
	UsersAndGroupsThatMayRestoreFilesAndDirectories = { "value" = "Administrators, Backup Operators" }
	UsersAndGroupsThatMayShutDownTheSystem = { "value" = "Administrators" }
	UsersOrGroupsThatMayTakeOwnershipOfFilesOrOtherObjects = { "value" = "Administrators" }
	SendFileSamplesWhenFurtherAnalysisIsRequired = { "value" = "1" }
	AllowIndexingOfEncryptedFiles = { "value" = "0" }
	AllowTelemetry = { "value" = "2" }
	AllowUnencryptedTraffic = { "value" = "0" }
	AlwaysInstallWithElevatedPrivileges = { "value" = "0" }
	AlwaysPromptForPasswordUponConnection = { "value" = "1" }
	ApplicationSpecifyTheMaximumLogFileSizeKB = { "value" = "32768" }
	AutomaticallySendMemoryDumpsForOSgeneratedErrorReports = { "value" = "1" }
	ConfigureDefaultConsent = { "value" = "4" }
	ConfigureWindowsSmartScreen = { "value" = "1" }
	DisallowDigestAuthentication = { "value" = "0" }
	DisallowWinRMFromStoringRunAsCredentials = { "value" = "1" }
	DoNotAllowPasswordsToBeSaved = { "value" = "1" }
	SecuritySpecifyTheMaximumLogFileSizeKB = { "value" = "196608" }
	SetClientConnectionEncryptionLevel = { "value" = "3" }
	SetTheDefaultBehaviorForAutoRun = { "value" = "1" }
	SetupSpecifyTheMaximumLogFileSizeKB = { "value" = "32768" }
	SystemSpecifyTheMaximumLogFileSizeKB = { "value" = "32768" }
	TurnOffDataExecutionPreventionForExplorer = { "value" = "0" }
	SpecifyTheIntervalToCheckForDefinitionUpdates = { "value" = "8" }
	WindowsFirewallDomainUseProfileSettings = { "value" = "1" }
	WindowsFirewallDomainBehaviorForOutboundConnections = { "value" = "0" }
	WindowsFirewallDomainApplyLocalConnectionSecurityRules = { "value" = "1" }
	WindowsFirewallDomainApplyLocalFirewallRules = { "value" = "1" }
	WindowsFirewallDomainDisplayNotifications = { "value" = "1" }
	WindowsFirewallPrivateUseProfileSettings = { "value" = "1" }
	WindowsFirewallPrivateBehaviorForOutboundConnections = { "value" = "0" }
	WindowsFirewallPrivateApplyLocalConnectionSecurityRules = { "value" = "1" }
	WindowsFirewallPrivateApplyLocalFirewallRules = { "value" = "1" }
	WindowsFirewallPrivateDisplayNotifications = { "value" = "1" }
	WindowsFirewallPublicUseProfileSettings = { "value" = "1" }
	WindowsFirewallPublicBehaviorForOutboundConnections = { "value" = "0" }
	WindowsFirewallPublicApplyLocalConnectionSecurityRules = { "value" = "1" }
	WindowsFirewallPublicApplyLocalFirewallRules = { "value" = "1" }
	WindowsFirewallPublicDisplayNotifications = { "value" = "1" }
	WindowsFirewallDomainAllowUnicastResponse = { "value" = "0" }
	WindowsFirewallPrivateAllowUnicastResponse = { "value" = "0" }
	WindowsFirewallPublicAllowUnicastResponse = { "value" = "1" }
	MinimumTLSVersion = { "value" = "1.1" }
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
output "example_PO_Audit_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_PO_Audit.id
  description = "The IDs of the Policy Assignments."
}

output "example_PO_Audit_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_PO_Audit_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_PO_Audit.id
  description = "The ID of the Policy Set Definition."
}
