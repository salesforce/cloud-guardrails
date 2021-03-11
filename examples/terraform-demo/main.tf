locals {
  name_example_noparams = "example_noparams"
  subscription_name_example_noparams = "redscar-dev"
  management_group_example_noparams = ""
  enforcement_mode_example_noparams = false
  policy_names_example_noparams = [
    # -----------------------------------------------------------------------------------------------------------------
    # API for FHIR
    # -----------------------------------------------------------------------------------------------------------------
    "Azure API for FHIR should use a customer-managed key to encrypt data at rest",
    "Azure API for FHIR should use private link",
    "CORS should not allow every domain to access your API for FHIR",

    # -----------------------------------------------------------------------------------------------------------------
    # App Configuration
    # -----------------------------------------------------------------------------------------------------------------
    "App Configuration should use a customer-managed key",
    "App Configuration should use private link",

    # -----------------------------------------------------------------------------------------------------------------
    # App Platform
    # -----------------------------------------------------------------------------------------------------------------
    "[Preview]: Audit Azure Spring Cloud instances where distributed tracing is not enabled",

    # -----------------------------------------------------------------------------------------------------------------
    # App Service
    # -----------------------------------------------------------------------------------------------------------------
    "API App should only be accessible over HTTPS",
    "Authentication should be enabled on your API app",
    "Authentication should be enabled on your Function app",
    "Authentication should be enabled on your web app",
    "CORS should not allow every resource to access your API App",
    "CORS should not allow every resource to access your Function Apps",
    "CORS should not allow every resource to access your Web Applications",
    "Diagnostic logs in App Services should be enabled",
    "Ensure API app has 'Client Certificates (Incoming client certificates)' set to 'On'",
    "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'",
    "Ensure that 'HTTP Version' is the latest, if used to run the API app",
    "Ensure that 'HTTP Version' is the latest, if used to run the Function app",
    "Ensure that 'HTTP Version' is the latest, if used to run the Web app",
    "FTPS only should be required in your API App",
    "FTPS only should be required in your Function App",
    "FTPS should be required in your Web App",
    "Function App should only be accessible over HTTPS",
    "Function apps should have 'Client Certificates (Incoming client certificates)' enabled",
    "Latest TLS version should be used in your API App",
    "Latest TLS version should be used in your Function App",
    "Latest TLS version should be used in your Web App",
    "Managed identity should be used in your API App",
    "Managed identity should be used in your Function App",
    "Managed identity should be used in your Web App",
    "Remote debugging should be turned off for API Apps",
    "Remote debugging should be turned off for Function Apps",
    "Remote debugging should be turned off for Web Applications",
    "Web Application should only be accessible over HTTPS",

    # -----------------------------------------------------------------------------------------------------------------
    # Attestation
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Attestation providers should use private endpoints",

    # -----------------------------------------------------------------------------------------------------------------
    # Automation
    # -----------------------------------------------------------------------------------------------------------------
    "Automation account variables should be encrypted",
    "Azure Automation accounts should use customer-managed keys to encrypt data at rest",

    # -----------------------------------------------------------------------------------------------------------------
    # Azure Data Explorer
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Data Explorer encryption at rest should use a customer-managed key",
    "Disk encryption should be enabled on Azure Data Explorer",
    "Double encryption should be enabled on Azure Data Explorer",
    "Virtual network injection should be enabled for Azure Data Explorer",

    # -----------------------------------------------------------------------------------------------------------------
    # Azure Stack Edge
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Stack Edge devices should use double-encryption",

    # -----------------------------------------------------------------------------------------------------------------
    # Backup
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Backup should be enabled for Virtual Machines",

    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Batch account should use customer-managed keys to encrypt data",
    "Public network access should be disabled for Batch accounts",

    # -----------------------------------------------------------------------------------------------------------------
    # Bot Service
    # -----------------------------------------------------------------------------------------------------------------
    "Bot Service endpoint should be a valid HTTPS URI",
    "Bot Service should be encrypted with a customer-managed key",

    # -----------------------------------------------------------------------------------------------------------------
    # Cache
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Cache for Redis should reside within a virtual network",
    "Only secure connections to your Azure Cache for Redis should be enabled",

    # -----------------------------------------------------------------------------------------------------------------
    # Cognitive Services
    # -----------------------------------------------------------------------------------------------------------------
    "Cognitive Services accounts should enable data encryption",
    "Cognitive Services accounts should enable data encryption with a customer-managed key",
    "Cognitive Services accounts should restrict network access",
    "Cognitive Services accounts should use customer owned storage",
    "Cognitive Services accounts should use customer owned storage or enable data encryption.",
    "Public network access should be disabled for Cognitive Services accounts",

    # -----------------------------------------------------------------------------------------------------------------
    # Compute
    # -----------------------------------------------------------------------------------------------------------------
    "Audit VMs that do not use managed disks",
    "Audit virtual machines without disaster recovery configured",
    "Microsoft Antimalware for Azure should be configured to automatically update protection signatures",
    "Microsoft IaaSAntimalware extension should be deployed on Windows servers",
    "Require automatic OS image patching on Virtual Machine Scale Sets",
    "Unattached disks should be encrypted",
    "Virtual machines should be migrated to new Azure Resource Manager resources",

    # -----------------------------------------------------------------------------------------------------------------
    # Container Registry
    # -----------------------------------------------------------------------------------------------------------------
    "Container registries should be encrypted with a customer-managed key",
    "Container registries should not allow unrestricted network access",
    "Container registries should use private link",

    # -----------------------------------------------------------------------------------------------------------------
    # Cosmos DB
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Cosmos DB accounts should have firewall rules",
    "Azure Cosmos DB accounts should use customer-managed keys to encrypt data at rest",
    "Azure Cosmos DB key based metadata write access should be disabled",

    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "Azure data factories should be encrypted with a customer-managed key",
    "Public network access on Azure Data Factory should be disabled",
    "[Preview]: Azure Data Factory linked services should use Key Vault for storing secrets",
    "[Preview]: Azure Data Factory linked services should use system-assigned managed identity authentication when it is supported",
    "[Preview]: Azure Data Factory should use a Git repository for source control",

    # -----------------------------------------------------------------------------------------------------------------
    # Data Lake
    # -----------------------------------------------------------------------------------------------------------------
    "Require encryption on Data Lake Store accounts",

    # -----------------------------------------------------------------------------------------------------------------
    # Event Grid
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Event Grid domains should disable public network access",
    "Azure Event Grid domains should use private link",
    "Azure Event Grid topics should disable public network access",
    "Azure Event Grid topics should use private link",

    # -----------------------------------------------------------------------------------------------------------------
    # Event Hub
    # -----------------------------------------------------------------------------------------------------------------
    "All authorization rules except RootManageSharedAccessKey should be removed from Event Hub namespace",
    "Authorization rules on the Event Hub instance should be defined",
    "Event Hub namespaces should use a customer-managed key for encryption",

    # -----------------------------------------------------------------------------------------------------------------
    # General
    # -----------------------------------------------------------------------------------------------------------------
    "Audit resource location matches resource group location",
    "Audit usage of custom RBAC rules",
    "Custom subscription owner roles should not exist",

    # -----------------------------------------------------------------------------------------------------------------
    # HDInsight
    # -----------------------------------------------------------------------------------------------------------------
    "Azure HDInsight clusters should use customer-managed keys to encrypt data at rest",
    "Azure HDInsight clusters should use encryption at host to encrypt data at rest",
    "Azure HDInsight clusters should use encryption in transit to encrypt communication between Azure HDInsight cluster nodes",

    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Key Vault Managed HSM should have purge protection enabled",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "[Preview]: Firewall should be enabled on Key Vault",
    "[Preview]: Key Vault keys should have an expiration date",
    "[Preview]: Key Vault secrets should have an expiration date",
    "[Preview]: Keys should be backed by a hardware security module (HSM)",
    "[Preview]: Private endpoint should be configured for Key Vault",
    "[Preview]: Secrets should have content type set",

    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters",
    "Both operating systems and data disks in Azure Kubernetes Service clusters should be encrypted by customer-managed keys",
    "Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host",

    # -----------------------------------------------------------------------------------------------------------------
    # Lighthouse
    # -----------------------------------------------------------------------------------------------------------------
    "Audit delegation of scopes to a managing tenant",

    # -----------------------------------------------------------------------------------------------------------------
    # Machine Learning
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Machine Learning workspaces should be encrypted with a customer-managed key",
    "Azure Machine Learning workspaces should use private link",

    # -----------------------------------------------------------------------------------------------------------------
    # Managed Application
    # -----------------------------------------------------------------------------------------------------------------
    "Application definition for Managed Application should use customer provided storage account",

    # -----------------------------------------------------------------------------------------------------------------
    # Monitoring
    # -----------------------------------------------------------------------------------------------------------------
    "Activity log should be retained for at least one year",
    "Azure Monitor Logs clusters should be created with infrastructure-encryption enabled (double encryption)",
    "Azure Monitor Logs clusters should be encrypted with customer-managed key",
    "Azure Monitor Logs for Application Insights should be linked to a Log Analytics workspace",
    "Azure Monitor log profile should collect logs for categories 'write,' 'delete,' and 'action'",
    "Azure Monitor should collect activity logs from all regions",
    "Azure Monitor solution 'Security and Audit' must be deployed",
    "Azure subscriptions should have a log profile for Activity Log",
    "Saved-queries in Azure Monitor should be saved in customer storage account for logs encryption",
    "Storage account containing the container with activity logs must be encrypted with BYOK",
    "The Log Analytics agent should be installed on Virtual Machine Scale Sets",
    "The Log Analytics agent should be installed on virtual machines",
    "Workbooks should be saved to storage accounts that you control",
    "[Preview]: Log Analytics agent should be installed on your Linux Azure Arc machines",
    "[Preview]: Log Analytics agent should be installed on your Windows Azure Arc machines",
    "[Preview]: Network traffic data collection agent should be installed on Linux virtual machines",
    "[Preview]: Network traffic data collection agent should be installed on Windows virtual machines",

    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "App Service should use a virtual network service endpoint",
    "Azure VPN gateways should not use 'basic' SKU",
    "Cosmos DB should use a virtual network service endpoint",
    "Event Hub should use a virtual network service endpoint",
    "Flow log should be configured for every network security group",
    "Gateway subnets should not be configured with a network security group",
    "Key Vault should use a virtual network service endpoint",
    "Network interfaces should disable IP forwarding",
    "Network interfaces should not have public IPs",
    "RDP access from the Internet should be blocked",
    "SQL Server should use a virtual network service endpoint",
    "SSH access from the Internet should be blocked",
    "Service Bus should use a virtual network service endpoint",
    "Storage Accounts should use a virtual network service endpoint",
    "Web Application Firewall (WAF) should be enabled for Application Gateway",
    "Web Application Firewall (WAF) should be enabled for Azure Front Door Service service",
    "[Preview]: All Internet traffic should be routed via your deployed Azure Firewall",
    "[Preview]: Container Registry should use a virtual network service endpoint",

    # -----------------------------------------------------------------------------------------------------------------
    # Portal
    # -----------------------------------------------------------------------------------------------------------------
    "Shared dashboards should not have markdown tiles with inline content",

    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "Advanced data security should be enabled on SQL Managed Instance",
    "Advanced data security should be enabled on your SQL servers",
    "An Azure Active Directory administrator should be provisioned for SQL servers",
    "Azure SQL Database should have the minimal TLS version of 1.2",
    "Bring your own key data protection should be enabled for MySQL servers",
    "Bring your own key data protection should be enabled for PostgreSQL servers",
    "Connection throttling should be enabled for PostgreSQL database servers",
    "Disconnections should be logged for PostgreSQL database servers.",
    "Enforce SSL connection should be enabled for MySQL database servers",
    "Enforce SSL connection should be enabled for PostgreSQL database servers",
    "Geo-redundant backup should be enabled for Azure Database for MariaDB",
    "Geo-redundant backup should be enabled for Azure Database for MySQL",
    "Geo-redundant backup should be enabled for Azure Database for PostgreSQL",
    "Infrastructure encryption should be enabled for Azure Database for MySQL servers",
    "Infrastructure encryption should be enabled for Azure Database for PostgreSQL servers",
    "Log checkpoints should be enabled for PostgreSQL database servers",
    "Log connections should be enabled for PostgreSQL database servers",
    "Log duration should be enabled for PostgreSQL database servers",
    "Long-term geo-redundant backup should be enabled for Azure SQL Databases",
    "MariaDB server should use a virtual network service endpoint",
    "MySQL server should use a virtual network service endpoint",
    "PostgreSQL server should use a virtual network service endpoint",
    "Private endpoint connections on Azure SQL Database should be enabled",
    "Private endpoint should be enabled for MariaDB servers",
    "Private endpoint should be enabled for MySQL servers",
    "Private endpoint should be enabled for PostgreSQL servers",
    "Public network access on Azure SQL Database should be disabled",
    "Public network access should be disabled for MariaDB servers",
    "Public network access should be disabled for MySQL flexible servers",
    "Public network access should be disabled for MySQL servers",
    "Public network access should be disabled for PostgreSQL flexible servers",
    "Public network access should be disabled for PostgreSQL servers",
    "SQL Auditing settings should have Action-Groups configured to capture critical activities",
    "SQL Database should avoid using GRS backup redundancy",
    "SQL Managed Instance should have the minimal TLS version of 1.2",
    "SQL Managed Instances should avoid using GRS backup redundancy",
    "SQL managed instances should use customer-managed keys to encrypt data at rest",
    "SQL servers should be configured with 90 days auditing retention or higher",
    "SQL servers should use customer-managed keys to encrypt data at rest",
    "Transparent Data Encryption on SQL databases should be enabled",
    "Vulnerability Assessment settings for SQL server should contain an email address to receive scan reports",
    "Vulnerability assessment should be enabled on SQL Managed Instance",
    "Vulnerability assessment should be enabled on your SQL servers",

    # -----------------------------------------------------------------------------------------------------------------
    # Security Center
    # -----------------------------------------------------------------------------------------------------------------
    "A maximum of 3 owners should be designated for your subscription",
    "A vulnerability assessment solution should be enabled on your virtual machines",
    "Adaptive application controls for defining safe applications should be enabled on your machines",
    "Adaptive network hardening recommendations should be applied on internet facing virtual machines",
    "All network ports should be restricted on network security groups associated to your virtual machine",
    "Allowlist rules in your adaptive application control policy should be updated",
    "Authorized IP ranges should be defined on Kubernetes Services",
    "Auto provisioning of the Log Analytics agent should be enabled on your subscription",
    "Azure DDoS Protection Standard should be enabled",
    "Azure Defender for App Service should be enabled",
    "Azure Defender for Azure SQL Database servers should be enabled",
    "Azure Defender for Key Vault should be enabled",
    "Azure Defender for Kubernetes should be enabled",
    "Azure Defender for SQL servers on machines should be enabled",
    "Azure Defender for Storage should be enabled",
    "Azure Defender for container registries should be enabled",
    "Azure Defender for servers should be enabled",
    "Deprecated accounts should be removed from your subscription",
    "Deprecated accounts with owner permissions should be removed from your subscription",
    "Disk encryption should be applied on virtual machines",
    "Email notification for high severity alerts should be enabled",
    "Email notification to subscription owner for high severity alerts should be enabled",
    "Endpoint protection solution should be installed on virtual machine scale sets",
    "External accounts with owner permissions should be removed from your subscription",
    "External accounts with read permissions should be removed from your subscription",
    "External accounts with write permissions should be removed from your subscription",
    "Guest Configuration extension should be installed on your machines",
    "IP Forwarding on your virtual machine should be disabled",
    "Internet-facing virtual machines should be protected with network security groups",
    "Kubernetes Services should be upgraded to a non-vulnerable Kubernetes version",
    "Log Analytics agent health issues should be resolved on your machines",
    "Log Analytics agent should be installed on your virtual machine for Azure Security Center monitoring",
    "Log Analytics agent should be installed on your virtual machine scale sets for Azure Security Center monitoring",
    "MFA should be enabled accounts with write permissions on your subscription",
    "MFA should be enabled on accounts with owner permissions on your subscription",
    "MFA should be enabled on accounts with read permissions on your subscription",
    "Management ports of virtual machines should be protected with just-in-time network access control",
    "Management ports should be closed on your virtual machines",
    "Monitor missing Endpoint Protection in Azure Security Center",
    "Non-internet-facing virtual machines should be protected with network security groups",
    "Operating system version should be the most current version for your cloud service roles",
    "Role-Based Access Control (RBAC) should be used on Kubernetes Services",
    "Security Center standard pricing tier should be selected",
    "Service principals should be used to protect your subscriptions instead of management certificates",
    "Subnets should be associated with a Network Security Group",
    "Subscriptions should have a contact email address for security issues",
    "System updates on virtual machine scale sets should be installed",
    "System updates should be installed on your machines",
    "There should be more than one owner assigned to your subscription",
    "Virtual machines' Guest Configuration extension should be deployed with system-assigned managed identity",
    "Vulnerabilities in Azure Container Registry images should be remediated",
    "Vulnerabilities in container security configurations should be remediated",
    "Vulnerabilities in security configuration on your machines should be remediated",
    "Vulnerabilities in security configuration on your virtual machine scale sets should be remediated",
    "Vulnerabilities on your SQL databases should be remediated",
    "Vulnerabilities on your SQL servers on machine should be remediated",
    "[Preview]: Sensitive data in your SQL databases should be classified",

    # -----------------------------------------------------------------------------------------------------------------
    # Service Bus
    # -----------------------------------------------------------------------------------------------------------------
    "All authorization rules except RootManageSharedAccessKey should be removed from Service Bus namespace",
    "Service Bus Premium namespaces should use a customer-managed key for encryption",

    # -----------------------------------------------------------------------------------------------------------------
    # Service Fabric
    # -----------------------------------------------------------------------------------------------------------------
    "Service Fabric clusters should have the ClusterProtectionLevel property set to EncryptAndSign",
    "Service Fabric clusters should only use Azure Active Directory for client authentication",

    # -----------------------------------------------------------------------------------------------------------------
    # SignalR
    # -----------------------------------------------------------------------------------------------------------------
    "Azure SignalR Service should use private link",

    # -----------------------------------------------------------------------------------------------------------------
    # Storage
    # -----------------------------------------------------------------------------------------------------------------
    "Geo-redundant storage should be enabled for Storage Accounts",
    "Secure transfer to storage accounts should be enabled",
    "Storage account should use a private link connection",
    "Storage accounts should allow access from trusted Microsoft services",
    "Storage accounts should be migrated to new Azure Resource Manager resources",
    "Storage accounts should have infrastructure encryption",
    "Storage accounts should restrict network access",
    "Storage accounts should restrict network access using virtual network rules",
    "Storage accounts should use customer-managed key for encryption",
    "[Preview]: Storage account public access should be disallowed",

    # -----------------------------------------------------------------------------------------------------------------
    # Stream Analytics
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Stream Analytics jobs should use customer-managed keys to encrypt data",

    # -----------------------------------------------------------------------------------------------------------------
    # Synapse
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Synapse workspaces should allow outbound data traffic only to approved targets",
    "Azure Synapse workspaces should use customer-managed keys to encrypt data at rest",
    "IP firewall rules on Azure Synapse workspaces should be removed",
    "Managed workspace virtual network on Azure Synapse workspaces should be enabled",
    "Private endpoint connections on Azure Synapse workspaces should be enabled",
    "Vulnerability assessment should be enabled on your Synapse workspaces",

    # -----------------------------------------------------------------------------------------------------------------
    # VM Image Builder
    # -----------------------------------------------------------------------------------------------------------------
    "VM Image Builder templates should use private link",

  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "example_noparams" {
  count        = length(local.policy_names_example_noparams)
  display_name = element(local.policy_names_example_noparams, count.index)
}

locals {
  example_noparams_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.example_noparams.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_noparams" {
  count = local.management_group_example_noparams != "" ? 1 : 0
  display_name  = local.management_group_example_noparams
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_noparams" {
  count                 = local.subscription_name_example_noparams != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_noparams
}

locals {
  example_noparams_scope = local.management_group_example_noparams != "" ? data.azurerm_management_group.example_noparams[0].id : element(data.azurerm_subscriptions.example_noparams[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "example_noparams" {
  name                  = local.name_example_noparams
  policy_type           = "Custom"
  display_name          = local.name_example_noparams
  description           = local.name_example_noparams
  management_group_name = local.management_group_example_noparams == "" ? null : local.management_group_example_noparams
  policy_definitions    = tostring(jsonencode(local.example_noparams_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_example_noparams
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_noparams" {
  name                 = local.name_example_noparams
  policy_definition_id = azurerm_policy_set_definition.example_noparams.id
  scope                = local.example_noparams_scope
  enforcement_mode     = local.enforcement_mode_example_noparams
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_noparams.*.id
  description = "The IDs of the Policy Assignments."
}

output "scope" {
  value       = local.example_noparams_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_noparams.id
  description = "The ID of the Policy Set Definition."
}

output "count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_names_example_noparams)
}

