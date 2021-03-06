variable "name" { default = "example" }

module "example" {
  source                         = "../../azure_guardrails/shared/terraform/policy-initiative-with-builtins"
  description                    = var.name
  display_name                   = var.name
  subscription_name              = "example"
  management_group               = ""
  enforcement_mode               = false
  policy_set_definition_category = var.name
  policy_set_name                = var.name
  policy_names = [
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
    "Audit Azure Spring Cloud instances where distributed tracing is not enabled",
    
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
    "Ensure Function app is using the latest version of TLS encryption",
    "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'",
    "Ensure WEB app is using the latest version of TLS encryption ",
    "Ensure that '.NET Framework' version is the latest, if used as a part of the API app",
    "Ensure that '.NET Framework' version is the latest, if used as a part of the Function App",
    "Ensure that '.NET Framework' version is the latest, if used as a part of the Web app",
    "Ensure that 'HTTP Version' is the latest, if used to run the API app",
    "Ensure that 'HTTP Version' is the latest, if used to run the Function app",
    "Ensure that 'HTTP Version' is the latest, if used to run the Web app",
    "Ensure that Register with Azure Active Directory is enabled on API app",
    "Ensure that Register with Azure Active Directory is enabled on Function App",
    "Ensure that Register with Azure Active Directory is enabled on WEB App",
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
    "Azure Data Factory linked services should use Key Vault for storing secrets",
    "Azure Data Factory linked services should use system-assigned managed identity authentication when it is supported",
    "Azure Data Factory should use a Git repository for source control",
    "Azure data factories should be encrypted with a customer-managed key",
    "Public network access on Azure Data Factory should be disabled",
    
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
    "Allow resource creation only in Asia data centers",
    "Allow resource creation only in European data centers",
    "Allow resource creation only in India data centers",
    "Allow resource creation only in United States data centers",
    "Audit resource location matches resource group location",
    "Audit usage of custom RBAC rules",
    "Custom subscription owner roles should not exist",
    
    # -----------------------------------------------------------------------------------------------------------------
    # Guest Configuration
    # -----------------------------------------------------------------------------------------------------------------
    "Audit Linux virtual machines on which the Linux Guest Configuration extension is not enabled",
    "Audit Windows virtual machines on which the Windows Guest Configuration extension is not enabled",
    "Show audit results from Linux VMs that allow remote connections from accounts without passwords",
    "Show audit results from Linux VMs that do not have the passwd file permissions set to 0644",
    "Show audit results from Linux VMs that do not have the specified applications installed",
    "Show audit results from Linux VMs that have accounts without passwords",
    "Show audit results from Linux VMs that have the specified applications installed",
    "Show audit results from Windows Server VMs on which Windows Serial Console is not enabled",
    "Show audit results from Windows VMs configurations in 'Administrative Templates - Control Panel'",
    "Show audit results from Windows VMs configurations in 'Administrative Templates - MSS (Legacy)'",
    "Show audit results from Windows VMs configurations in 'Administrative Templates - Network'",
    "Show audit results from Windows VMs configurations in 'Administrative Templates - System'",
    "Show audit results from Windows VMs configurations in 'Security Options - Accounts'",
    "Show audit results from Windows VMs configurations in 'Security Options - Audit'",
    "Show audit results from Windows VMs configurations in 'Security Options - Devices'",
    "Show audit results from Windows VMs configurations in 'Security Options - Interactive Logon'",
    "Show audit results from Windows VMs configurations in 'Security Options - Microsoft Network Client'",
    "Show audit results from Windows VMs configurations in 'Security Options - Microsoft Network Server'",
    "Show audit results from Windows VMs configurations in 'Security Options - Network Access'",
    "Show audit results from Windows VMs configurations in 'Security Options - Network Security'",
    "Show audit results from Windows VMs configurations in 'Security Options - Recovery console'",
    "Show audit results from Windows VMs configurations in 'Security Options - Shutdown'",
    "Show audit results from Windows VMs configurations in 'Security Options - System objects'",
    "Show audit results from Windows VMs configurations in 'Security Options - System settings'",
    "Show audit results from Windows VMs configurations in 'Security Options - User Account Control'",
    "Show audit results from Windows VMs configurations in 'Security Settings - Account Policies'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Account Logon'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Account Management'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Detailed Tracking'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Logon-Logoff'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Object Access'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Policy Change'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - Privilege Use'",
    "Show audit results from Windows VMs configurations in 'System Audit Policies - System'",
    "Show audit results from Windows VMs configurations in 'User Rights Assignment'",
    "Show audit results from Windows VMs configurations in 'Windows Components'",
    "Show audit results from Windows VMs configurations in 'Windows Firewall Properties'",
    "Show audit results from Windows VMs if the Administrators group contains any of the specified members",
    "Show audit results from Windows VMs if the Administrators group doesn't contain all of the specified members",
    "Show audit results from Windows VMs if the Administrators group doesn't contain only specified members",
    "Show audit results from Windows VMs on which Windows Defender Exploit Guard is not enabled",
    "Show audit results from Windows VMs on which the DSC configuration is not compliant",
    "Show audit results from Windows VMs on which the Log Analytics agent is not connected as expected",
    "Show audit results from Windows VMs on which the remote connection status does not match the specified one",
    "Show audit results from Windows VMs on which the specified services are not installed and 'Running'",
    "Show audit results from Windows VMs that allow re-use of the previous 24 passwords",
    "Show audit results from Windows VMs that are not joined to the specified domain",
    "Show audit results from Windows VMs that are not set to the specified time zone",
    "Show audit results from Windows VMs that contain certificates expiring within the specified number of days",
    "Show audit results from Windows VMs that do not contain the specified certificates in Trusted Root",
    "Show audit results from Windows VMs that do not have a maximum password age of 70 days",
    "Show audit results from Windows VMs that do not have a minimum password age of 1 day",
    "Show audit results from Windows VMs that do not have the password complexity setting enabled",
    "Show audit results from Windows VMs that do not have the specified Windows PowerShell execution policy",
    "Show audit results from Windows VMs that do not have the specified Windows PowerShell modules installed",
    "Show audit results from Windows VMs that do not have the specified applications installed",
    "Show audit results from Windows VMs that do not restrict the minimum password length to 14 characters",
    "Show audit results from Windows VMs that do not store passwords using reversible encryption",
    "Show audit results from Windows VMs that have not restarted within the specified number of days",
    "Show audit results from Windows VMs that have the specified applications installed",
    "Show audit results from Windows VMs with a pending reboot",
    "Show audit results from Windows web servers that are not using secure communication protocols",
    
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
    "Firewall should be enabled on Key Vault",
    "Key Vault keys should have an expiration date",
    "Key Vault secrets should have an expiration date",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "Keys should be backed by a hardware security module (HSM)",
    "Private endpoint should be configured for Key Vault",
    "Secrets should have content type set",
    
    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters",
    "Both operating systems and data disks in Azure Kubernetes Service clusters should be encrypted by customer-managed keys",
    "Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host",
    
    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes service
    # -----------------------------------------------------------------------------------------------------------------
    "Do not allow privileged containers in AKS",
    "Enforce HTTPS ingress in AKS",
    "Enforce internal load balancers in AKS",
    "Enforce unique ingress hostnames across namespaces in AKS",
    "Ensure CPU and memory resource limits defined on containers in AKS",
    
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
    "Log Analytics agent should be installed on your Linux Azure Arc machines",
    "Log Analytics agent should be installed on your Windows Azure Arc machines",
    "Network traffic data collection agent should be installed on Linux virtual machines",
    "Network traffic data collection agent should be installed on Windows virtual machines",
    "Saved-queries in Azure Monitor should be saved in customer storage account for logs encryption",
    "Storage account containing the container with activity logs must be encrypted with BYOK",
    "The Log Analytics agent should be installed on Virtual Machine Scale Sets",
    "The Log Analytics agent should be installed on virtual machines",
    "Workbooks should be saved to storage accounts that you control",
    
    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "All Internet traffic should be routed via your deployed Azure Firewall",
    "App Service should use a virtual network service endpoint",
    "Azure VPN gateways should not use 'basic' SKU",
    "Container Registry should use a virtual network service endpoint",
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
    "Web Application Firewall should be enabled for Azure Front Door Service or Application Gateway",
    
    # -----------------------------------------------------------------------------------------------------------------
    # Portal
    # -----------------------------------------------------------------------------------------------------------------
    "Shared dashboards should not have markdown tiles with inline content",
    
    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "Advanced Threat Protection types should be set to 'All' in SQL Managed Instance advanced data security settings",
    "Advanced Threat Protection types should be set to 'All' in SQL server Advanced Data Security settings",
    "Advanced data security settings for SQL Managed Instance should contain an email address for security alerts",
    "Advanced data security settings for SQL server should contain an email address to receive security alerts",
    "Advanced data security should be enabled on SQL Managed Instance",
    "Advanced data security should be enabled on your SQL servers",
    "An Azure Active Directory administrator should be provisioned for SQL servers",
    "Azure SQL Database should have the minimal TLS version of 1.2",
    "Bring your own key data protection should be enabled for MySQL servers",
    "Bring your own key data protection should be enabled for PostgreSQL servers",
    "Connection throttling should be enabled for PostgreSQL database servers",
    "Disconnections should be logged for PostgreSQL database servers.",
    "Email notifications to admins should be enabled in SQL Managed Instance advanced data security settings",
    "Email notifications to admins should be enabled in SQL server advanced data security settings",
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
    "Require SQL Server version 12.0",
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
    "A security contact phone number should be provided for your subscription",
    "A vulnerability assessment solution should be enabled on your virtual machines",
    "Access to App Services should be restricted",
    "Adaptive application controls for defining safe applications should be enabled on your machines",
    "Adaptive network hardening recommendations should be applied on internet facing virtual machines",
    "All network ports should be restricted on network security groups associated to your virtual machine",
    "Allowlist rules in your adaptive application control policy should be updated",
    "Authorized IP ranges should be defined on Kubernetes Services",
    "Auto provisioning of the Log Analytics agent should be enabled on your subscription",
    "Automatic provisioning of security monitoring agent",
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
    "Enable Azure Security Center on your subscription",
    "Enable Security Center's auto provisioning of the Log Analytics agent on your subscriptions with default workspace.",
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
    "Monitor unaudited SQL servers in Azure Security Center",
    "Monitor unencrypted SQL databases in Azure Security Center",
    "Non-internet-facing virtual machines should be protected with network security groups",
    "Operating system version should be the most current version for your cloud service roles",
    "Pod Security Policies should be defined on Kubernetes Services",
    "Role-Based Access Control (RBAC) should be used on Kubernetes Services",
    "Security Center standard pricing tier should be selected",
    "Sensitive data in your SQL databases should be classified",
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
    "Vulnerabilities should be remediated by a Vulnerability Assessment solution",
    "Web ports should be restricted on Network Security Groups associated to your VM",
    
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
    "Storage account public access should be disallowed",
    "Storage account should use a private link connection",
    "Storage accounts should allow access from trusted Microsoft services",
    "Storage accounts should be migrated to new Azure Resource Manager resources",
    "Storage accounts should have infrastructure encryption",
    "Storage accounts should restrict network access",
    "Storage accounts should restrict network access using virtual network rules",
    "Storage accounts should use customer-managed key for encryption",
    
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
    # Tags
    # -----------------------------------------------------------------------------------------------------------------
    "Allow resource creation if 'department' tag set",
    "Allow resource creation if 'environment' tag value in allowed values",
    
    # -----------------------------------------------------------------------------------------------------------------
    # VM Image Builder
    # -----------------------------------------------------------------------------------------------------------------
    "VM Image Builder templates should use private link",
    
  ]
}
