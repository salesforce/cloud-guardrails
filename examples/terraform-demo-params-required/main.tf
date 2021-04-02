locals {
  name_example_PR_Audit = "example_PR_Audit"
  subscription_name_example_PR_Audit = "example"
  management_group_example_PR_Audit = ""
  category_example_PR_Audit = "Testing"
  enforcement_mode_example_PR_Audit = false
  policy_ids_example_PR_Audit = [
    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "26ee67a2-f81a-4ba8-b9ce-8550bd5ee1a7", # Metric alert rules should be configured on Batch accounts

    # -----------------------------------------------------------------------------------------------------------------
    # Compute
    # -----------------------------------------------------------------------------------------------------------------
    "cccc23c7-8427-4f53-ad12-b6a63eb452b3", # Allowed virtual machine size SKUs
    "d461a302-a187-421a-89ac-84acdb4edc04", # Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption
    "c0e996f8-39cf-4af9-9f45-83fbde810432", # Only approved VM extensions should be installed
    "7c1b1214-f927-48bf-8882-84f0af6588b1", # Resource logs in Virtual Machine Scale Sets should be enabled

    # -----------------------------------------------------------------------------------------------------------------
    # Cosmos DB
    # -----------------------------------------------------------------------------------------------------------------
    "0473574d-2d43-4217-aefe-941fcdf7e684", # Azure Cosmos DB allowed locations
    "0b7ef78e-a035-4f23-b9bd-aff122a1b1cf", # Azure Cosmos DB throughput should be limited

    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "6809a3d0-d354-42fb-b955-783d207c62a8", # [Preview]: Azure Data Factory linked service resource type should be in allow list

    # -----------------------------------------------------------------------------------------------------------------
    # General
    # -----------------------------------------------------------------------------------------------------------------
    "e56962a6-4747-49cd-b67b-bf8b01975c4c", # Allowed locations
    "e765b5de-1225-4ba3-bd56-1ac6695af988", # Allowed locations for resource groups
    "a08ec900-254a-4555-9bf5-e42af04b5c5c", # Allowed resource types
    "6c112d4e-5bc7-47ae-a041-ea2d9dccd749", # Not allowed resource types

    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "a22f4a40-01d3-4c7d-8071-da157eeff341", # [Preview]: Certificates should be issued by the specified non-integrated certificate authority
    "12ef42cb-9903-4e39-9c26-422d29570417", # [Preview]: Certificates should have the specified lifetime action triggers
    "f772fb64-8e40-40ad-87bc-7706e1949427", # [Preview]: Certificates should not expire within the specified number of days
    "cee51871-e572-4576-855c-047c820360f0", # [Preview]: Certificates using RSA cryptography should have the specified minimum key size
    "5ff38825-c5d8-47c5-b70e-069a21955146", # [Preview]: Keys should have more than the specified number of days before expiration
    "49a22571-d204-4c91-a7b6-09b1a586fbc9", # [Preview]: Keys should have the specified maximum validity period
    "c26e4b24-cf98-4c67-b48b-5a25c4c69eb9", # [Preview]: Keys should not be active for longer than the specified number of days
    "82067dbb-e53b-4e06-b631-546d197452d9", # [Preview]: Keys using RSA cryptography should have a specified minimum key size
    "b0eb591a-5e70-4534-a8bf-04b9c489584a", # [Preview]: Secrets should have more than the specified number of days before expiration
    "342e8053-e12e-4c44-be01-c3c2f318400f", # [Preview]: Secrets should have the specified maximum validity period
    "e8d99835-8a06-45ae-a8e0-87a91941ccfe", # [Preview]: Secrets should not be active for longer than the specified number of days

    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "e345eecc-fa47-480f-9e88-67dcc122b164", # Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits
    "47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8", # Kubernetes cluster containers should not share host process ID or host IPC namespace
    "56d0a13f-712f-466b-8416-56fb354fb823", # Kubernetes cluster containers should not use forbidden sysctl interfaces
    "440b515e-a580-421e-abeb-b159a61ddcbc", # Kubernetes cluster containers should only listen on allowed ports
    "511f5417-5d12-434d-ab2e-816901e72a5e", # Kubernetes cluster containers should only use allowed AppArmor profiles
    "f85eb0dd-92ee-40e9-8a76-db25a507d6d3", # Kubernetes cluster containers should only use allowed ProcMountType
    "c26596ff-4d70-4e6a-9a30-c2506bd2f80c", # Kubernetes cluster containers should only use allowed capabilities
    "febd0533-8e55-448f-b837-bd0e06f16469", # Kubernetes cluster containers should only use allowed images
    "975ce327-682c-4f2e-aa46-b9598289b86c", # Kubernetes cluster containers should only use allowed seccomp profiles
    "df49d893-a74c-421d-bc95-c663042e5b80", # Kubernetes cluster containers should run with a read only root file system
    "f4a8fce0-2dd5-4c21-9a36-8f0ec809d663", # Kubernetes cluster pod FlexVolume volumes should only use allowed drivers
    "098fc59e-46c7-4d99-9b16-64990e543d75", # Kubernetes cluster pod hostPath volumes should only use allowed host paths
    "f06ddb64-5fa3-4b77-b166-acb36f7f6042", # Kubernetes cluster pods and containers should only run with approved user and group IDs
    "e1e6c427-07d9-46ab-9689-bfa85431e636", # Kubernetes cluster pods and containers should only use allowed SELinux options
    "16697877-1118-4fb1-9b65-9898ec2509ec", # Kubernetes cluster pods should only use allowed volume types
    "82985f06-dc18-4a48-bc1c-b9f4f0098cfe", # Kubernetes cluster pods should only use approved host network and port range
    "46592696-4c7b-4bf3-9e45-6c2763bdc0a6", # Kubernetes cluster pods should use specified labels
    "233a2a17-77ca-4fb1-9b6b-69223d272a44", # Kubernetes cluster services should listen only on allowed ports
    "95edb821-ddaf-4404-9732-666045e056b4", # Kubernetes cluster should not allow privileged containers
    "1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d", # Kubernetes clusters should be accessible only over HTTPS
    "1c6e92c9-99f0-4e55-9cf2-0c234dc48f99", # Kubernetes clusters should not allow container privilege escalation
    "3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e", # Kubernetes clusters should use internal load balancers
    "d46c275d-1680-448d-b2ec-e495a3b6cc89", # [Preview]: Kubernetes cluster services should only use allowed external IPs
    "423dd1ba-798e-40e4-9c4d-b6902674b423", # [Preview]: Kubernetes clusters should disable automounting API credentials
    "d2e7ea85-6b44-4317-a0be-1b951587f626", # [Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities
    "a27c700f-8a22-44ec-961c-41625264370b", # [Preview]: Kubernetes clusters should not use specific security capabilities
    "9f061a12-e40d-4183-a00e-171812443373", # [Preview]: Kubernetes clusters should not use the default namespace

    # -----------------------------------------------------------------------------------------------------------------
    # Lighthouse
    # -----------------------------------------------------------------------------------------------------------------
    "7a8a51a3-ad87-4def-96f3-65a1839242b6", # Allow managing tenant ids to onboard through Azure Lighthouse

    # -----------------------------------------------------------------------------------------------------------------
    # Machine Learning
    # -----------------------------------------------------------------------------------------------------------------
    "77eeea86-7e81-4a7d-9067-de844d096752", # [Preview]: Configure allowed Python packages for specified Azure Machine Learning computes
    "53c70b02-63dd-11ea-bc55-0242ac130003", # [Preview]: Configure allowed module authors for specified Azure Machine Learning computes
    "5853517a-63de-11ea-bc55-0242ac130003", # [Preview]: Configure allowed registries for specified Azure Machine Learning computes
    "3948394e-63de-11ea-bc55-0242ac130003", # [Preview]: Configure an approval endpoint called prior to jobs running for specified Azure Machine Learning computes
    "6a6f7384-63de-11ea-bc55-0242ac130003", # [Preview]: Configure code signing for training code for specified Azure Machine Learning computes
    "1d413020-63de-11ea-bc55-0242ac130003", # [Preview]: Configure log filter expressions and datastore to be used for full logs for specified Azure Machine Learning computes

    # -----------------------------------------------------------------------------------------------------------------
    # Monitoring
    # -----------------------------------------------------------------------------------------------------------------
    "b954148f-4c11-4c38-8221-be76711e194a", # An activity log alert should exist for specific Administrative operations
    "c5447c04-a4d7-4ba8-a263-c9ee321a6858", # An activity log alert should exist for specific Policy operations
    "3b980d31-7904-4bb7-8575-5665739a8052", # An activity log alert should exist for specific Security operations
    "f47b5582-33ec-4c5c-87c0-b010a6b2e917", # Audit Log Analytics workspace for VM - Report Mismatch
    "7f89b1eb-583c-429a-8828-af049802c1d9", # Audit diagnostic setting
    "11ac78e3-31bc-4f0c-8434-37ab963cea07", # Dependency agent should be enabled for listed virtual machine images
    "e2dd799a-a932-4e9d-ac17-d473bc3c6c10", # Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images
    "5c3bc7b8-a64c-4e08-a9cd-7ff0f31e1138", # Log Analytics agent should be enabled in virtual machine scale sets for listed virtual machine images
    "32133ab0-ee4b-4b44-98d6-042180979d50", # [Preview]: Log Analytics Agent should be enabled for listed virtual machine images

    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "50b83b09-03da-41c1-b656-c293c914862b", # A custom IPsec/IKE policy must be applied to all Azure virtual network gateway connections
    "b6e2945c-0b7b-40f5-9233-7a5323b5cdc6", # Network Watcher should be enabled
    "d416745a-506c-48b6-8ab1-83cb814bcaa3", # Virtual machines should be connected to an approved virtual network
    "f1776c76-f58c-4245-a8d0-2b207198dc8b", # Virtual networks should use specified virtual network gateway

    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "77e8b146-0078-4fb2-b002-e112381199f0", # Virtual network firewall rule on Azure SQL Database should be enabled to allow traffic from the specified subnet

    # -----------------------------------------------------------------------------------------------------------------
    # Storage
    # -----------------------------------------------------------------------------------------------------------------
    "7433c107-6db4-4ad1-b57a-a76dce0154a1", # Storage accounts should be limited by allowed SKUs

    # -----------------------------------------------------------------------------------------------------------------
    # Synapse
    # -----------------------------------------------------------------------------------------------------------------
    "3a003702-13d2-4679-941b-937e58c443f0", # Synapse managed private endpoints should only connect to resources in approved Azure Active Directory tenants

    # -----------------------------------------------------------------------------------------------------------------
    # Tags
    # -----------------------------------------------------------------------------------------------------------------
    "8ce3da23-7156-49e4-b145-24f95f9dcb46", # Require a tag and its value on resource groups
    "1e30110a-5ceb-460c-a204-c1c3969c6d62", # Require a tag and its value on resources
    "96670d01-0a4d-4649-9c89-2d3abc0a5025", # Require a tag on resource groups
    "871b6d14-10aa-478d-b590-94f262ecfa99", # Require a tag on resources

  ]
  policy_definition_map = {"Metric alert rules should be configured on Batch accounts" = "/providers/Microsoft.Authorization/policyDefinitions/26ee67a2-f81a-4ba8-b9ce-8550bd5ee1a7",
    "Allowed virtual machine size SKUs" = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3",
    "Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption" = "/providers/Microsoft.Authorization/policyDefinitions/d461a302-a187-421a-89ac-84acdb4edc04",
    "Only approved VM extensions should be installed" = "/providers/Microsoft.Authorization/policyDefinitions/c0e996f8-39cf-4af9-9f45-83fbde810432",
    "Resource logs in Virtual Machine Scale Sets should be enabled" = "/providers/Microsoft.Authorization/policyDefinitions/7c1b1214-f927-48bf-8882-84f0af6588b1",
    "Azure Cosmos DB allowed locations" = "/providers/Microsoft.Authorization/policyDefinitions/0473574d-2d43-4217-aefe-941fcdf7e684",
    "Azure Cosmos DB throughput should be limited" = "/providers/Microsoft.Authorization/policyDefinitions/0b7ef78e-a035-4f23-b9bd-aff122a1b1cf",
    "[Preview]: Azure Data Factory linked service resource type should be in allow list" = "/providers/Microsoft.Authorization/policyDefinitions/6809a3d0-d354-42fb-b955-783d207c62a8",
    "Allowed locations" = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
    "Allowed locations for resource groups" = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988",
    "Allowed resource types" = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c",
    "Not allowed resource types" = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749",
    "[Preview]: Certificates should be issued by the specified non-integrated certificate authority" = "/providers/Microsoft.Authorization/policyDefinitions/a22f4a40-01d3-4c7d-8071-da157eeff341",
    "[Preview]: Certificates should have the specified lifetime action triggers" = "/providers/Microsoft.Authorization/policyDefinitions/12ef42cb-9903-4e39-9c26-422d29570417",
    "[Preview]: Certificates should not expire within the specified number of days" = "/providers/Microsoft.Authorization/policyDefinitions/f772fb64-8e40-40ad-87bc-7706e1949427",
    "[Preview]: Certificates using RSA cryptography should have the specified minimum key size" = "/providers/Microsoft.Authorization/policyDefinitions/cee51871-e572-4576-855c-047c820360f0",
    "[Preview]: Keys should have more than the specified number of days before expiration" = "/providers/Microsoft.Authorization/policyDefinitions/5ff38825-c5d8-47c5-b70e-069a21955146",
    "[Preview]: Keys should have the specified maximum validity period" = "/providers/Microsoft.Authorization/policyDefinitions/49a22571-d204-4c91-a7b6-09b1a586fbc9",
    "[Preview]: Keys should not be active for longer than the specified number of days" = "/providers/Microsoft.Authorization/policyDefinitions/c26e4b24-cf98-4c67-b48b-5a25c4c69eb9",
    "[Preview]: Keys using RSA cryptography should have a specified minimum key size" = "/providers/Microsoft.Authorization/policyDefinitions/82067dbb-e53b-4e06-b631-546d197452d9",
    "[Preview]: Secrets should have more than the specified number of days before expiration" = "/providers/Microsoft.Authorization/policyDefinitions/b0eb591a-5e70-4534-a8bf-04b9c489584a",
    "[Preview]: Secrets should have the specified maximum validity period" = "/providers/Microsoft.Authorization/policyDefinitions/342e8053-e12e-4c44-be01-c3c2f318400f",
    "[Preview]: Secrets should not be active for longer than the specified number of days" = "/providers/Microsoft.Authorization/policyDefinitions/e8d99835-8a06-45ae-a8e0-87a91941ccfe",
    "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits" = "/providers/Microsoft.Authorization/policyDefinitions/e345eecc-fa47-480f-9e88-67dcc122b164",
    "Kubernetes cluster containers should not share host process ID or host IPC namespace" = "/providers/Microsoft.Authorization/policyDefinitions/47a1ee2f-2a2a-4576-bf2a-e0e36709c2b8",
    "Kubernetes cluster containers should not use forbidden sysctl interfaces" = "/providers/Microsoft.Authorization/policyDefinitions/56d0a13f-712f-466b-8416-56fb354fb823",
    "Kubernetes cluster containers should only listen on allowed ports" = "/providers/Microsoft.Authorization/policyDefinitions/440b515e-a580-421e-abeb-b159a61ddcbc",
    "Kubernetes cluster containers should only use allowed AppArmor profiles" = "/providers/Microsoft.Authorization/policyDefinitions/511f5417-5d12-434d-ab2e-816901e72a5e",
    "Kubernetes cluster containers should only use allowed ProcMountType" = "/providers/Microsoft.Authorization/policyDefinitions/f85eb0dd-92ee-40e9-8a76-db25a507d6d3",
    "Kubernetes cluster containers should only use allowed capabilities" = "/providers/Microsoft.Authorization/policyDefinitions/c26596ff-4d70-4e6a-9a30-c2506bd2f80c",
    "Kubernetes cluster containers should only use allowed images" = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469",
    "Kubernetes cluster containers should only use allowed seccomp profiles" = "/providers/Microsoft.Authorization/policyDefinitions/975ce327-682c-4f2e-aa46-b9598289b86c",
    "Kubernetes cluster containers should run with a read only root file system" = "/providers/Microsoft.Authorization/policyDefinitions/df49d893-a74c-421d-bc95-c663042e5b80",
    "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers" = "/providers/Microsoft.Authorization/policyDefinitions/f4a8fce0-2dd5-4c21-9a36-8f0ec809d663",
    "Kubernetes cluster pod hostPath volumes should only use allowed host paths" = "/providers/Microsoft.Authorization/policyDefinitions/098fc59e-46c7-4d99-9b16-64990e543d75",
    "Kubernetes cluster pods and containers should only run with approved user and group IDs" = "/providers/Microsoft.Authorization/policyDefinitions/f06ddb64-5fa3-4b77-b166-acb36f7f6042",
    "Kubernetes cluster pods and containers should only use allowed SELinux options" = "/providers/Microsoft.Authorization/policyDefinitions/e1e6c427-07d9-46ab-9689-bfa85431e636",
    "Kubernetes cluster pods should only use allowed volume types" = "/providers/Microsoft.Authorization/policyDefinitions/16697877-1118-4fb1-9b65-9898ec2509ec",
    "Kubernetes cluster pods should only use approved host network and port range" = "/providers/Microsoft.Authorization/policyDefinitions/82985f06-dc18-4a48-bc1c-b9f4f0098cfe",
    "Kubernetes cluster pods should use specified labels" = "/providers/Microsoft.Authorization/policyDefinitions/46592696-4c7b-4bf3-9e45-6c2763bdc0a6",
    "Kubernetes cluster services should listen only on allowed ports" = "/providers/Microsoft.Authorization/policyDefinitions/233a2a17-77ca-4fb1-9b6b-69223d272a44",
    "Kubernetes cluster should not allow privileged containers" = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4",
    "Kubernetes clusters should be accessible only over HTTPS" = "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
    "Kubernetes clusters should not allow container privilege escalation" = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99",
    "Kubernetes clusters should use internal load balancers" = "/providers/Microsoft.Authorization/policyDefinitions/3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e",
    "[Preview]: Kubernetes cluster services should only use allowed external IPs" = "/providers/Microsoft.Authorization/policyDefinitions/d46c275d-1680-448d-b2ec-e495a3b6cc89",
    "[Preview]: Kubernetes clusters should disable automounting API credentials" = "/providers/Microsoft.Authorization/policyDefinitions/423dd1ba-798e-40e4-9c4d-b6902674b423",
    "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities" = "/providers/Microsoft.Authorization/policyDefinitions/d2e7ea85-6b44-4317-a0be-1b951587f626",
    "[Preview]: Kubernetes clusters should not use specific security capabilities" = "/providers/Microsoft.Authorization/policyDefinitions/a27c700f-8a22-44ec-961c-41625264370b",
    "[Preview]: Kubernetes clusters should not use the default namespace" = "/providers/Microsoft.Authorization/policyDefinitions/9f061a12-e40d-4183-a00e-171812443373",
    "Allow managing tenant ids to onboard through Azure Lighthouse" = "/providers/Microsoft.Authorization/policyDefinitions/7a8a51a3-ad87-4def-96f3-65a1839242b6",
    "[Preview]: Configure allowed Python packages for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/77eeea86-7e81-4a7d-9067-de844d096752",
    "[Preview]: Configure allowed module authors for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/53c70b02-63dd-11ea-bc55-0242ac130003",
    "[Preview]: Configure allowed registries for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/5853517a-63de-11ea-bc55-0242ac130003",
    "[Preview]: Configure an approval endpoint called prior to jobs running for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/3948394e-63de-11ea-bc55-0242ac130003",
    "[Preview]: Configure code signing for training code for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/6a6f7384-63de-11ea-bc55-0242ac130003",
    "[Preview]: Configure log filter expressions and datastore to be used for full logs for specified Azure Machine Learning computes" = "/providers/Microsoft.Authorization/policyDefinitions/1d413020-63de-11ea-bc55-0242ac130003",
    "An activity log alert should exist for specific Administrative operations" = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a",
    "An activity log alert should exist for specific Policy operations" = "/providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858",
    "An activity log alert should exist for specific Security operations" = "/providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052",
    "Audit Log Analytics workspace for VM - Report Mismatch" = "/providers/Microsoft.Authorization/policyDefinitions/f47b5582-33ec-4c5c-87c0-b010a6b2e917",
    "Audit diagnostic setting" = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9",
    "Dependency agent should be enabled for listed virtual machine images" = "/providers/Microsoft.Authorization/policyDefinitions/11ac78e3-31bc-4f0c-8434-37ab963cea07",
    "Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images" = "/providers/Microsoft.Authorization/policyDefinitions/e2dd799a-a932-4e9d-ac17-d473bc3c6c10",
    "Log Analytics agent should be enabled in virtual machine scale sets for listed virtual machine images" = "/providers/Microsoft.Authorization/policyDefinitions/5c3bc7b8-a64c-4e08-a9cd-7ff0f31e1138",
    "[Preview]: Log Analytics Agent should be enabled for listed virtual machine images" = "/providers/Microsoft.Authorization/policyDefinitions/32133ab0-ee4b-4b44-98d6-042180979d50",
    "A custom IPsec/IKE policy must be applied to all Azure virtual network gateway connections" = "/providers/Microsoft.Authorization/policyDefinitions/50b83b09-03da-41c1-b656-c293c914862b",
    "Network Watcher should be enabled" = "/providers/Microsoft.Authorization/policyDefinitions/b6e2945c-0b7b-40f5-9233-7a5323b5cdc6",
    "Virtual machines should be connected to an approved virtual network" = "/providers/Microsoft.Authorization/policyDefinitions/d416745a-506c-48b6-8ab1-83cb814bcaa3",
    "Virtual networks should use specified virtual network gateway" = "/providers/Microsoft.Authorization/policyDefinitions/f1776c76-f58c-4245-a8d0-2b207198dc8b",
    "Virtual network firewall rule on Azure SQL Database should be enabled to allow traffic from the specified subnet" = "/providers/Microsoft.Authorization/policyDefinitions/77e8b146-0078-4fb2-b002-e112381199f0",
    "Storage accounts should be limited by allowed SKUs" = "/providers/Microsoft.Authorization/policyDefinitions/7433c107-6db4-4ad1-b57a-a76dce0154a1",
    "Synapse managed private endpoints should only connect to resources in approved Azure Active Directory tenants" = "/providers/Microsoft.Authorization/policyDefinitions/3a003702-13d2-4679-941b-937e58c443f0",
    "Require a tag and its value on resource groups" = "/providers/Microsoft.Authorization/policyDefinitions/8ce3da23-7156-49e4-b145-24f95f9dcb46",
    "Require a tag and its value on resources" = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62",
    "Require a tag on resource groups" = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025",
    "Require a tag on resources" = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_PR_Audit" {
  count = local.management_group_example_PR_Audit != "" ? 1 : 0
  display_name  = local.management_group_example_PR_Audit
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_PR_Audit" {
  count                 = local.subscription_name_example_PR_Audit != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_PR_Audit
}

locals {
  scope = local.management_group_example_PR_Audit != "" ? data.azurerm_management_group.example_PR_Audit[0].id : element(data.azurerm_subscriptions.example_PR_Audit[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_PR_Audit_definition_lookups" {
  count = length(local.policy_ids_example_PR_Audit)
  name  = local.policy_ids_example_PR_Audit[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_PR_Audit" {
  name                  = local.name_example_PR_Audit
  policy_type           = "Custom"
  display_name          = local.name_example_PR_Audit
  description           = local.name_example_PR_Audit
  management_group_name = local.management_group_example_PR_Audit == "" ? null : local.management_group_example_PR_Audit
  metadata = tostring(jsonencode({
    category = local.category_example_PR_Audit
  }))



  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Metric alert rules should be configured on Batch accounts")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        metricName = { "value" : "" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed virtual machine size SKUs")
    parameter_values = jsonencode({
        listOfAllowedSKUs = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption")
    parameter_values = jsonencode({
        allowedEncryptionSets = { "value" : [] }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Only approved VM extensions should be installed")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
        approvedExtensions = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Virtual Machine Scale Sets should be enabled")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        includeAKSClusters = { "value" : false }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Cosmos DB allowed locations")
    parameter_values = jsonencode({
        listOfAllowedLocations = { "value" : [] }
        policyEffect = { "value" : "deny" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Cosmos DB throughput should be limited")
    parameter_values = jsonencode({
        throughputMax = { "value" : 0 }
        effect = { "value" : "deny" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Azure Data Factory linked service resource type should be in allow list")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
        allowedLinkedServiceResourceTypes = { "value" : [] }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed locations")
    parameter_values = jsonencode({
        listOfAllowedLocations = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed locations for resource groups")
    parameter_values = jsonencode({
        listOfAllowedLocations = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed resource types")
    parameter_values = jsonencode({
        listOfResourceTypesAllowed = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Not allowed resource types")
    parameter_values = jsonencode({
        listOfResourceTypesNotAllowed = { "value" : [] }
        effect = { "value" : "Deny" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should be issued by the specified non-integrated certificate authority")
    parameter_values = jsonencode({
        caCommonName = { "value" : "" }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should have the specified lifetime action triggers")
    parameter_values = jsonencode({
        maximumPercentageLife = { "value" : 0 }
        minimumDaysBeforeExpiry = { "value" : 0 }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should not expire within the specified number of days")
    parameter_values = jsonencode({
        daysToExpire = { "value" : 0 }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates using RSA cryptography should have the specified minimum key size")
    parameter_values = jsonencode({
        minimumRSAKeySize = { "value" : 0 }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should have more than the specified number of days before expiration")
    parameter_values = jsonencode({
        minimumDaysBeforeExpiration = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should have the specified maximum validity period")
    parameter_values = jsonencode({
        maximumValidityInDays = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should not be active for longer than the specified number of days")
    parameter_values = jsonencode({
        maximumValidityInDays = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys using RSA cryptography should have a specified minimum key size")
    parameter_values = jsonencode({
        minimumRSAKeySize = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should have more than the specified number of days before expiration")
    parameter_values = jsonencode({
        minimumDaysBeforeExpiration = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should have the specified maximum validity period")
    parameter_values = jsonencode({
        maximumValidityInDays = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should not be active for longer than the specified number of days")
    parameter_values = jsonencode({
        maximumValidityInDays = { "value" : 0 }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        cpuLimit = { "value" : "" }
        memoryLimit = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should not share host process ID or host IPC namespace")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should not use forbidden sysctl interfaces")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        forbiddenSysctls = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only listen on allowed ports")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedContainerPortsList = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed AppArmor profiles")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedProfiles = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed ProcMountType")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        procMountType = { "value" : "Default" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed capabilities")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedCapabilities = { "value" : [] }
        requiredDropCapabilities = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed images")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedContainerImagesRegex = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed seccomp profiles")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedProfiles = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should run with a read only root file system")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedFlexVolumeDrivers = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod hostPath volumes should only use allowed host paths")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedHostPaths = { "value" : {"paths": []} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods and containers should only run with approved user and group IDs")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        runAsUserRule = { "value" : "MustRunAsNonRoot" }
        runAsUserRanges = { "value" : {"ranges": []} }
        runAsGroupRule = { "value" : "RunAsAny" }
        runAsGroupRanges = { "value" : {"ranges": []} }
        supplementalGroupsRule = { "value" : "RunAsAny" }
        supplementalGroupsRanges = { "value" : {"ranges": []} }
        fsGroupRule = { "value" : "RunAsAny" }
        fsGroupRanges = { "value" : {"ranges": []} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods and containers should only use allowed SELinux options")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedSELinuxOptions = { "value" : {"options": []} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should only use allowed volume types")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedVolumeTypes = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should only use approved host network and port range")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowHostNetwork = { "value" : false }
        minPort = { "value" : 0 }
        maxPort = { "value" : 0 }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should use specified labels")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        labelsList = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster services should listen only on allowed ports")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedServicePortsList = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster should not allow privileged containers")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should be accessible only over HTTPS")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not allow container privilege escalation")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should use internal load balancers")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes cluster services should only use allowed external IPs")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        allowedExternalIPs = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should disable automounting API credentials")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use specific security capabilities")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        disallowedCapabilities = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use the default namespace")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allow managing tenant ids to onboard through Azure Lighthouse")
    parameter_values = jsonencode({
        listOfAllowedTenants = { "value" : [] }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed Python packages for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        allowedPythonPackageChannels = { "value" : [] }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed module authors for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        allowedModuleAuthors = { "value" : [] }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed registries for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        allowedACRs = { "value" : [] }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure an approval endpoint called prior to jobs running for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        approvalEndpoint = { "value" : "" }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure code signing for training code for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        signingKey = { "value" : "" }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure log filter expressions and datastore to be used for full logs for specified Azure Machine Learning computes")
    parameter_values = jsonencode({
        computeNames = { "value" : [] }
        logFilters = { "value" : [] }
        datastore = { "value" : "" }
        effect = { "value" : "enforceSetting" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Administrative operations")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        operationName = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Policy operations")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        operationName = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Security operations")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        operationName = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Log Analytics workspace for VM - Report Mismatch")
    parameter_values = jsonencode({
        logAnalyticsWorkspaceId = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit diagnostic setting")
    parameter_values = jsonencode({
        listOfResourceTypes = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Dependency agent should be enabled for listed virtual machine images")
    parameter_values = jsonencode({
        listOfImageIdToInclude_windows = { "value" : [] }
        listOfImageIdToInclude_linux = { "value" : [] }
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images")
    parameter_values = jsonencode({
        listOfImageIdToInclude_windows = { "value" : [] }
        listOfImageIdToInclude_linux = { "value" : [] }
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Log Analytics agent should be enabled in virtual machine scale sets for listed virtual machine images")
    parameter_values = jsonencode({
        listOfImageIdToInclude_windows = { "value" : [] }
        listOfImageIdToInclude_linux = { "value" : [] }
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Log Analytics Agent should be enabled for listed virtual machine images")
    parameter_values = jsonencode({
        listOfImageIdToInclude_windows = { "value" : [] }
        listOfImageIdToInclude_linux = { "value" : [] }
        effect = { "value" : "AuditIfNotExists" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "A custom IPsec/IKE policy must be applied to all Azure virtual network gateway connections")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
        IPsecEncryption = { "value" : [] }
        IPsecIntegrity = { "value" : [] }
        IKEEncryption = { "value" : [] }
        IKEIntegrity = { "value" : [] }
        DHGroup = { "value" : [] }
        PFSGroup = { "value" : [] }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Network Watcher should be enabled")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        listOfLocations = { "value" : [] }
        resourceGroupName = { "value" : "NetworkWatcherRG" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual machines should be connected to an approved virtual network")
    parameter_values = jsonencode({
        effect = { "value" : "Audit" }
        virtualNetworkId = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual networks should use specified virtual network gateway")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        virtualNetworkGatewayId = { "value" : "" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual network firewall rule on Azure SQL Database should be enabled to allow traffic from the specified subnet")
    parameter_values = jsonencode({
        subnetId = { "value" : "" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should be limited by allowed SKUs")
    parameter_values = jsonencode({
        effect = { "value" : "Deny" }
        listOfAllowedSKUs = { "value" : [] }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Synapse managed private endpoints should only connect to resources in approved Azure Active Directory tenants")
    parameter_values = jsonencode({
        allowedTenantIds = { "value" : [] }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag and its value on resource groups")
    parameter_values = jsonencode({
        tagName = { "value" : "" }
        tagValue = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag and its value on resources")
    parameter_values = jsonencode({
        tagName = { "value" : "" }
        tagValue = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag on resource groups")
    parameter_values = jsonencode({
        tagName = { "value" : "" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag on resources")
    parameter_values = jsonencode({
        tagName = { "value" : "" }
    })
    reference_id = null
  }

}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_PR_Audit" {
  name                 = local.name_example_PR_Audit
  policy_definition_id = azurerm_policy_set_definition.example_PR_Audit.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_PR_Audit
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "example_PR_Audit_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_PR_Audit.id
  description = "The IDs of the Policy Assignments."
}

output "example_PR_Audit_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_PR_Audit_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_PR_Audit.id
  description = "The ID of the Policy Set Definition."
}

