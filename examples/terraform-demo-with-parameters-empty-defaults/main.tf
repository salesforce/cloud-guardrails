locals {
  name_example_params_required = "example_params_required"
  subscription_name_example_params_required = "example"
  management_group_example_params_required = ""
  category_example_params_required = "Testing"
  enforcement_mode_example_params_required = false
  policy_names = [
    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "Metric alert rules should be configured on Batch accounts",
    # -----------------------------------------------------------------------------------------------------------------
    # Compute
    # -----------------------------------------------------------------------------------------------------------------
    "Allowed virtual machine size SKUs",
    "Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption",
    "Only approved VM extensions should be installed",
    "Resource logs in Virtual Machine Scale Sets should be enabled",
    # -----------------------------------------------------------------------------------------------------------------
    # Cosmos DB
    # -----------------------------------------------------------------------------------------------------------------
    "Azure Cosmos DB allowed locations",
    "Azure Cosmos DB throughput should be limited",
    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "[Preview]: Azure Data Factory linked service resource type should be in allow list",
    # -----------------------------------------------------------------------------------------------------------------
    # General
    # -----------------------------------------------------------------------------------------------------------------
    "Allowed locations",
    "Allowed locations for resource groups",
    "Allowed resource types",
    "Not allowed resource types",
    # -----------------------------------------------------------------------------------------------------------------
    # Guest Configuration
    # -----------------------------------------------------------------------------------------------------------------
    "Audit Linux machines that don't have the specified applications installed",
    "Audit Linux machines that have the specified applications installed",
    "Audit Windows machines missing any of specified members in the Administrators group",
    "Audit Windows machines network connectivity",
    "Audit Windows machines on which the Log Analytics agent is not connected as expected",
    "Audit Windows machines on which the specified services are not installed and 'Running'",
    "Audit Windows machines that are not joined to the specified domain",
    "Audit Windows machines that are not set to the specified time zone",
    "Audit Windows machines that contain certificates expiring within the specified number of days",
    "Audit Windows machines that do not contain the specified certificates in Trusted Root",
    "Audit Windows machines that do not have the specified Windows PowerShell execution policy",
    "Audit Windows machines that do not have the specified Windows PowerShell modules installed",
    "Audit Windows machines that don't have the specified applications installed",
    "Audit Windows machines that have the specified applications installed",
    "Audit Windows machines that have the specified members in the Administrators group",
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "[Preview]: Certificates should be issued by the specified non-integrated certificate authority",
    "[Preview]: Certificates should have the specified lifetime action triggers",
    "[Preview]: Certificates should not expire within the specified number of days",
    "[Preview]: Certificates using RSA cryptography should have the specified minimum key size",
    "[Preview]: Keys should have more than the specified number of days before expiration",
    "[Preview]: Keys should have the specified maximum validity period",
    "[Preview]: Keys should not be active for longer than the specified number of days",
    "[Preview]: Keys using RSA cryptography should have a specified minimum key size",
    "[Preview]: Secrets should have more than the specified number of days before expiration",
    "[Preview]: Secrets should have the specified maximum validity period",
    "[Preview]: Secrets should not be active for longer than the specified number of days",
    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits",
    "Kubernetes cluster containers should not share host process ID or host IPC namespace",
    "Kubernetes cluster containers should not use forbidden sysctl interfaces",
    "Kubernetes cluster containers should only listen on allowed ports",
    "Kubernetes cluster containers should only use allowed AppArmor profiles",
    "Kubernetes cluster containers should only use allowed ProcMountType",
    "Kubernetes cluster containers should only use allowed capabilities",
    "Kubernetes cluster containers should only use allowed images",
    "Kubernetes cluster containers should only use allowed seccomp profiles",
    "Kubernetes cluster containers should run with a read only root file system",
    "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers",
    "Kubernetes cluster pod hostPath volumes should only use allowed host paths",
    "Kubernetes cluster pods and containers should only run with approved user and group IDs",
    "Kubernetes cluster pods and containers should only use allowed SELinux options",
    "Kubernetes cluster pods should only use allowed volume types",
    "Kubernetes cluster pods should only use approved host network and port range",
    "Kubernetes cluster pods should use specified labels",
    "Kubernetes cluster services should listen only on allowed ports",
    "Kubernetes cluster should not allow privileged containers",
    "Kubernetes clusters should be accessible only over HTTPS",
    "Kubernetes clusters should not allow container privilege escalation",
    "Kubernetes clusters should use internal load balancers",
    "[Preview]: Kubernetes cluster services should only use allowed external IPs",
    "[Preview]: Kubernetes clusters should disable automounting API credentials",
    "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities",
    "[Preview]: Kubernetes clusters should not use specific security capabilities",
    "[Preview]: Kubernetes clusters should not use the default namespace",
    # -----------------------------------------------------------------------------------------------------------------
    # Lighthouse
    # -----------------------------------------------------------------------------------------------------------------
    "Allow managing tenant ids to onboard through Azure Lighthouse",
    # -----------------------------------------------------------------------------------------------------------------
    # Machine Learning
    # -----------------------------------------------------------------------------------------------------------------
    "[Preview]: Configure allowed Python packages for specified Azure Machine Learning computes",
    "[Preview]: Configure allowed module authors for specified Azure Machine Learning computes",
    "[Preview]: Configure allowed registries for specified Azure Machine Learning computes",
    "[Preview]: Configure an approval endpoint called prior to jobs running for specified Azure Machine Learning computes",
    "[Preview]: Configure code signing for training code for specified Azure Machine Learning computes",
    "[Preview]: Configure log filter expressions and datastore to be used for full logs for specified Azure Machine Learning computes",
    # -----------------------------------------------------------------------------------------------------------------
    # Monitoring
    # -----------------------------------------------------------------------------------------------------------------
    "An activity log alert should exist for specific Administrative operations",
    "An activity log alert should exist for specific Policy operations",
    "An activity log alert should exist for specific Security operations",
    "Audit Log Analytics workspace for VM - Report Mismatch",
    "Audit diagnostic setting",
    "Dependency agent should be enabled for listed virtual machine images",
    "Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images",
    "Log Analytics agent should be enabled in virtual machine scale sets for listed virtual machine images",
    "[Preview]: Log Analytics Agent should be enabled for listed virtual machine images",
    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "A custom IPsec/IKE policy must be applied to all Azure virtual network gateway connections",
    "Network Watcher should be enabled",
    "Virtual machines should be connected to an approved virtual network",
    "Virtual networks should use specified virtual network gateway",
    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "Virtual network firewall rule on Azure SQL Database should be enabled to allow traffic from the specified subnet",
    # -----------------------------------------------------------------------------------------------------------------
    # Storage
    # -----------------------------------------------------------------------------------------------------------------
    "Storage accounts should be limited by allowed SKUs",
    # -----------------------------------------------------------------------------------------------------------------
    # Synapse
    # -----------------------------------------------------------------------------------------------------------------
    "Synapse managed private endpoints should only connect to resources in approved Azure Active Directory tenants",
    # -----------------------------------------------------------------------------------------------------------------
    # Tags
    # -----------------------------------------------------------------------------------------------------------------
    "Require a tag and its value on resource groups",
    "Require a tag and its value on resources",
    "Require a tag on resource groups",
    "Require a tag on resources",
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.example_params_required_definition_lookups.*.display_name,
    data.azurerm_policy_definition.example_params_required_definition_lookups.*.id
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "example_params_required" {
  count = local.management_group_example_params_required != "" ? 1 : 0
  display_name  = local.management_group_example_params_required
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "example_params_required" {
  count                 = local.subscription_name_example_params_required != "" ? 1 : 0
  display_name_contains = local.subscription_name_example_params_required
}

locals {
  scope = local.management_group_example_params_required != "" ? data.azurerm_management_group.example_params_required[0].id : element(data.azurerm_subscriptions.example_params_required[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Definition Lookups
# ---------------------------------------------------------------------------------------------------------------------

data "azurerm_policy_definition" "example_params_required_definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Initiative Definition
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_policy_set_definition" "example_params_required" {
  name                  = local.name_example_params_required
  policy_type           = "Custom"
  display_name          = local.name_example_params_required
  description           = local.name_example_params_required
  management_group_name = local.management_group_example_params_required == "" ? null : local.management_group_example_params_required
  metadata = tostring(jsonencode({
    category = local.category_example_params_required
  }))

  
  
  
  
  
  
  
  
  
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Metric alert rules should be configured on Batch accounts")
    parameter_values = jsonencode({ 
      metricName = { "value" : "[parameters('metricName')]" }
    })
    reference_id = null
  }
  
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed virtual machine size SKUs")
    parameter_values = jsonencode({ 
      listOfAllowedSKUs = { "value" : "[parameters('listOfAllowedSKUs')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Managed disks should use a specific set of disk encryption sets for the customer-managed key encryption")
    parameter_values = jsonencode({ 
      allowedEncryptionSets = { "value" : "[parameters('allowedEncryptionSets')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Only approved VM extensions should be installed")
    parameter_values = jsonencode({ 
      approvedExtensions = { "value" : "[parameters('approvedExtensions')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Virtual Machine Scale Sets should be enabled")
    parameter_values = jsonencode({ 
      includeAKSClusters = { "value" : "[parameters('includeAKSClusters')]" }
    })
    reference_id = null
  }
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Cosmos DB allowed locations")
    parameter_values = jsonencode({ 
      listOfAllowedLocations = { "value" : "[parameters('listOfAllowedLocations')]" }
      policyEffect = { "value" : "[parameters('policyEffect')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Azure Cosmos DB throughput should be limited")
    parameter_values = jsonencode({ 
      throughputMax = { "value" : "[parameters('throughputMax')]" }
    })
    reference_id = null
  }
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Azure Data Factory linked service resource type should be in allow list")
    parameter_values = jsonencode({ 
      allowedLinkedServiceResourceTypes = { "value" : "[parameters('allowedLinkedServiceResourceTypes')]" }
    })
    reference_id = null
  }
  
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed locations")
    parameter_values = jsonencode({ 
      listOfAllowedLocations = { "value" : "[parameters('listOfAllowedLocations')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed locations for resource groups")
    parameter_values = jsonencode({ 
      listOfAllowedLocations = { "value" : "[parameters('listOfAllowedLocations')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allowed resource types")
    parameter_values = jsonencode({ 
      listOfResourceTypesAllowed = { "value" : "[parameters('listOfResourceTypesAllowed')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Not allowed resource types")
    parameter_values = jsonencode({ 
      listOfResourceTypesNotAllowed = { "value" : "[parameters('listOfResourceTypesNotAllowed')]" }
    })
    reference_id = null
  }
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Linux machines that don't have the specified applications installed")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ApplicationName = { "value" : "[parameters('ApplicationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Linux machines that have the specified applications installed")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ApplicationName = { "value" : "[parameters('ApplicationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines missing any of specified members in the Administrators group")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      MembersToInclude = { "value" : "[parameters('MembersToInclude')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines network connectivity")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      host = { "value" : "[parameters('host')]" }
      port = { "value" : "[parameters('port')]" }
      shouldConnect = { "value" : "[parameters('shouldConnect')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines on which the Log Analytics agent is not connected as expected")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      WorkspaceId = { "value" : "[parameters('WorkspaceId')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines on which the specified services are not installed and 'Running'")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ServiceName = { "value" : "[parameters('ServiceName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that are not joined to the specified domain")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      DomainName = { "value" : "[parameters('DomainName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that are not set to the specified time zone")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      TimeZone = { "value" : "[parameters('TimeZone')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that contain certificates expiring within the specified number of days")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      CertificateStorePath = { "value" : "[parameters('CertificateStorePath')]" }
      ExpirationLimitInDays = { "value" : "[parameters('ExpirationLimitInDays')]" }
      CertificateThumbprintsToInclude = { "value" : "[parameters('CertificateThumbprintsToInclude')]" }
      CertificateThumbprintsToExclude = { "value" : "[parameters('CertificateThumbprintsToExclude')]" }
      IncludeExpiredCertificates = { "value" : "[parameters('IncludeExpiredCertificates')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not contain the specified certificates in Trusted Root")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      CertificateThumbprints = { "value" : "[parameters('CertificateThumbprints')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not have the specified Windows PowerShell execution policy")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ExecutionPolicy = { "value" : "[parameters('ExecutionPolicy')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that do not have the specified Windows PowerShell modules installed")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      Modules = { "value" : "[parameters('Modules')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that don't have the specified applications installed")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      installedApplication = { "value" : "[parameters('installedApplication')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that have the specified applications installed")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      ApplicationName = { "value" : "[parameters('ApplicationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Windows machines that have the specified members in the Administrators group")
    parameter_values = jsonencode({ 
      IncludeArcMachines = { "value" : "[parameters('IncludeArcMachines')]" }
      MembersToExclude = { "value" : "[parameters('MembersToExclude')]" }
    })
    reference_id = null
  }
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should be issued by the specified non-integrated certificate authority")
    parameter_values = jsonencode({ 
      caCommonName = { "value" : "[parameters('caCommonName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should have the specified lifetime action triggers")
    parameter_values = jsonencode({ 
      maximumPercentageLife = { "value" : "[parameters('maximumPercentageLife')]" }
      minimumDaysBeforeExpiry = { "value" : "[parameters('minimumDaysBeforeExpiry')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates should not expire within the specified number of days")
    parameter_values = jsonencode({ 
      daysToExpire = { "value" : "[parameters('daysToExpire')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Certificates using RSA cryptography should have the specified minimum key size")
    parameter_values = jsonencode({ 
      minimumRSAKeySize = { "value" : "[parameters('minimumRSAKeySize')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should have more than the specified number of days before expiration")
    parameter_values = jsonencode({ 
      minimumDaysBeforeExpiration = { "value" : "[parameters('minimumDaysBeforeExpiration')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should have the specified maximum validity period")
    parameter_values = jsonencode({ 
      maximumValidityInDays = { "value" : "[parameters('maximumValidityInDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys should not be active for longer than the specified number of days")
    parameter_values = jsonencode({ 
      maximumValidityInDays = { "value" : "[parameters('maximumValidityInDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Keys using RSA cryptography should have a specified minimum key size")
    parameter_values = jsonencode({ 
      minimumRSAKeySize = { "value" : "[parameters('minimumRSAKeySize')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should have more than the specified number of days before expiration")
    parameter_values = jsonencode({ 
      minimumDaysBeforeExpiration = { "value" : "[parameters('minimumDaysBeforeExpiration')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should have the specified maximum validity period")
    parameter_values = jsonencode({ 
      maximumValidityInDays = { "value" : "[parameters('maximumValidityInDays')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Secrets should not be active for longer than the specified number of days")
    parameter_values = jsonencode({ 
      maximumValidityInDays = { "value" : "[parameters('maximumValidityInDays')]" }
    })
    reference_id = null
  }
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers CPU and memory resource limits should not exceed the specified limits")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      cpuLimit = { "value" : "[parameters('cpuLimit')]" }
      memoryLimit = { "value" : "[parameters('memoryLimit')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should not share host process ID or host IPC namespace")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should not use forbidden sysctl interfaces")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      forbiddenSysctls = { "value" : "[parameters('forbiddenSysctls')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only listen on allowed ports")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedContainerPortsList = { "value" : "[parameters('allowedContainerPortsList')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed AppArmor profiles")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedProfiles = { "value" : "[parameters('allowedProfiles')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed ProcMountType")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      procMountType = { "value" : "[parameters('procMountType')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed capabilities")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedCapabilities = { "value" : "[parameters('allowedCapabilities')]" }
      requiredDropCapabilities = { "value" : "[parameters('requiredDropCapabilities')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed images")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedContainerImagesRegex = { "value" : "[parameters('allowedContainerImagesRegex')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed seccomp profiles")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedProfiles = { "value" : "[parameters('allowedProfiles')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should run with a read only root file system")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedFlexVolumeDrivers = { "value" : "[parameters('allowedFlexVolumeDrivers')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod hostPath volumes should only use allowed host paths")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedHostPaths = { "value" : "[parameters('allowedHostPaths')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods and containers should only run with approved user and group IDs")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      runAsUserRule = { "value" : "[parameters('runAsUserRule')]" }
      runAsUserRanges = { "value" : "[parameters('runAsUserRanges')]" }
      runAsGroupRule = { "value" : "[parameters('runAsGroupRule')]" }
      runAsGroupRanges = { "value" : "[parameters('runAsGroupRanges')]" }
      supplementalGroupsRule = { "value" : "[parameters('supplementalGroupsRule')]" }
      supplementalGroupsRanges = { "value" : "[parameters('supplementalGroupsRanges')]" }
      fsGroupRule = { "value" : "[parameters('fsGroupRule')]" }
      fsGroupRanges = { "value" : "[parameters('fsGroupRanges')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods and containers should only use allowed SELinux options")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedSELinuxOptions = { "value" : "[parameters('allowedSELinuxOptions')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should only use allowed volume types")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedVolumeTypes = { "value" : "[parameters('allowedVolumeTypes')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should only use approved host network and port range")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowHostNetwork = { "value" : "[parameters('allowHostNetwork')]" }
      minPort = { "value" : "[parameters('minPort')]" }
      maxPort = { "value" : "[parameters('maxPort')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should use specified labels")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      labelsList = { "value" : "[parameters('labelsList')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster services should listen only on allowed ports")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedServicePortsList = { "value" : "[parameters('allowedServicePortsList')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster should not allow privileged containers")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should be accessible only over HTTPS")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not allow container privilege escalation")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should use internal load balancers")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes cluster services should only use allowed external IPs")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      allowedExternalIPs = { "value" : "[parameters('allowedExternalIPs')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should disable automounting API credentials")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use specific security capabilities")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
      disallowedCapabilities = { "value" : "[parameters('disallowedCapabilities')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use the default namespace")
    parameter_values = jsonencode({ 
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      labelSelector = { "value" : "[parameters('labelSelector')]" }
    })
    reference_id = null
  }
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Allow managing tenant ids to onboard through Azure Lighthouse")
    parameter_values = jsonencode({ 
      listOfAllowedTenants = { "value" : "[parameters('listOfAllowedTenants')]" }
    })
    reference_id = null
  }
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed Python packages for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      allowedPythonPackageChannels = { "value" : "[parameters('allowedPythonPackageChannels')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed module authors for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      allowedModuleAuthors = { "value" : "[parameters('allowedModuleAuthors')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure allowed registries for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      allowedACRs = { "value" : "[parameters('allowedACRs')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure an approval endpoint called prior to jobs running for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      approvalEndpoint = { "value" : "[parameters('approvalEndpoint')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure code signing for training code for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      signingKey = { "value" : "[parameters('signingKey')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Configure log filter expressions and datastore to be used for full logs for specified Azure Machine Learning computes")
    parameter_values = jsonencode({ 
      computeNames = { "value" : "[parameters('computeNames')]" }
      logFilters = { "value" : "[parameters('logFilters')]" }
      datastore = { "value" : "[parameters('datastore')]" }
    })
    reference_id = null
  }
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Administrative operations")
    parameter_values = jsonencode({ 
      operationName = { "value" : "[parameters('operationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Policy operations")
    parameter_values = jsonencode({ 
      operationName = { "value" : "[parameters('operationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "An activity log alert should exist for specific Security operations")
    parameter_values = jsonencode({ 
      operationName = { "value" : "[parameters('operationName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit Log Analytics workspace for VM - Report Mismatch")
    parameter_values = jsonencode({ 
      logAnalyticsWorkspaceId = { "value" : "[parameters('logAnalyticsWorkspaceId')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Audit diagnostic setting")
    parameter_values = jsonencode({ 
      listOfResourceTypes = { "value" : "[parameters('listOfResourceTypes')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Dependency agent should be enabled for listed virtual machine images")
    parameter_values = jsonencode({ 
      listOfImageIdToInclude_windows = { "value" : "[parameters('listOfImageIdToInclude_windows')]" }
      listOfImageIdToInclude_linux = { "value" : "[parameters('listOfImageIdToInclude_linux')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images")
    parameter_values = jsonencode({ 
      listOfImageIdToInclude_windows = { "value" : "[parameters('listOfImageIdToInclude_windows')]" }
      listOfImageIdToInclude_linux = { "value" : "[parameters('listOfImageIdToInclude_linux')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Log Analytics agent should be enabled in virtual machine scale sets for listed virtual machine images")
    parameter_values = jsonencode({ 
      listOfImageIdToInclude_windows = { "value" : "[parameters('listOfImageIdToInclude_windows')]" }
      listOfImageIdToInclude_linux = { "value" : "[parameters('listOfImageIdToInclude_linux')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Log Analytics Agent should be enabled for listed virtual machine images")
    parameter_values = jsonencode({ 
      listOfImageIdToInclude_windows = { "value" : "[parameters('listOfImageIdToInclude_windows')]" }
      listOfImageIdToInclude_linux = { "value" : "[parameters('listOfImageIdToInclude_linux')]" }
    })
    reference_id = null
  }
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "A custom IPsec/IKE policy must be applied to all Azure virtual network gateway connections")
    parameter_values = jsonencode({ 
      IPsecEncryption = { "value" : "[parameters('IPsecEncryption')]" }
      IPsecIntegrity = { "value" : "[parameters('IPsecIntegrity')]" }
      IKEEncryption = { "value" : "[parameters('IKEEncryption')]" }
      IKEIntegrity = { "value" : "[parameters('IKEIntegrity')]" }
      DHGroup = { "value" : "[parameters('DHGroup')]" }
      PFSGroup = { "value" : "[parameters('PFSGroup')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Network Watcher should be enabled")
    parameter_values = jsonencode({ 
      listOfLocations = { "value" : "[parameters('listOfLocations')]" }
      resourceGroupName = { "value" : "[parameters('resourceGroupName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual machines should be connected to an approved virtual network")
    parameter_values = jsonencode({ 
      virtualNetworkId = { "value" : "[parameters('virtualNetworkId')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual networks should use specified virtual network gateway")
    parameter_values = jsonencode({ 
      virtualNetworkGatewayId = { "value" : "[parameters('virtualNetworkGatewayId')]" }
    })
    reference_id = null
  }
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Virtual network firewall rule on Azure SQL Database should be enabled to allow traffic from the specified subnet")
    parameter_values = jsonencode({ 
      subnetId = { "value" : "[parameters('subnetId')]" }
    })
    reference_id = null
  }
  
  
  
  
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Storage accounts should be limited by allowed SKUs")
    parameter_values = jsonencode({ 
      listOfAllowedSKUs = { "value" : "[parameters('listOfAllowedSKUs')]" }
    })
    reference_id = null
  }
  
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Synapse managed private endpoints should only connect to resources in approved Azure Active Directory tenants")
    parameter_values = jsonencode({ 
      allowedTenantIds = { "value" : "[parameters('allowedTenantIds')]" }
    })
    reference_id = null
  }
  
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag and its value on resource groups")
    parameter_values = jsonencode({ 
      tagName = { "value" : "[parameters('tagName')]" }
      tagValue = { "value" : "[parameters('tagValue')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag and its value on resources")
    parameter_values = jsonencode({ 
      tagName = { "value" : "[parameters('tagName')]" }
      tagValue = { "value" : "[parameters('tagValue')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag on resource groups")
    parameter_values = jsonencode({ 
      tagName = { "value" : "[parameters('tagName')]" }
    })
    reference_id = null
  }
  
  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Require a tag on resources")
    parameter_values = jsonencode({ 
      tagName = { "value" : "[parameters('tagName')]" }
    })
    reference_id = null
  }
  
  

  parameters = <<PARAMETERS
{
    "metricName": {
        "name": "metricName",
        "type": "String",
        "description": "The metric name that an alert rule must be enabled on",
        "display_name": "Metric name"
    },
    "listOfAllowedSKUs": {
        "name": "listOfAllowedSKUs",
        "type": "Array",
        "description": "The list of SKUs that can be specified for storage accounts.",
        "display_name": "Allowed SKUs",
        "strong_type": "StorageSKUs"
    },
    "allowedEncryptionSets": {
        "name": "allowedEncryptionSets",
        "type": "Array",
        "description": "The list of allowed disk encryption sets for managed disks.",
        "display_name": "Allowed disk encryption set",
        "strong_type": "Microsoft.Compute/diskEncryptionSets"
    },
    "approvedExtensions": {
        "name": "approvedExtensions",
        "type": "Array",
        "description": "The list of approved extension types that can be installed. Example: AzureDiskEncryption",
        "display_name": "Approved extensions"
    },
    "includeAKSClusters": {
        "name": "includeAKSClusters",
        "type": "Boolean",
        "description": "Whether to include AKS Clusters to resource logs extension - True or False",
        "display_name": "Include AKS Clusters"
    },
    "listOfAllowedLocations": {
        "name": "listOfAllowedLocations",
        "type": "Array",
        "description": "The list of locations that resource groups can be created in.",
        "display_name": "Allowed locations",
        "strong_type": "location"
    },
    "policyEffect": {
        "name": "policyEffect",
        "type": "String",
        "description": "The desired effect of the policy.",
        "display_name": "Policy Effect",
        "default_value": "deny",
        "allowed_values": [
            "deny",
            "audit",
            "disabled"
        ]
    },
    "throughputMax": {
        "name": "throughputMax",
        "type": "Integer",
        "description": "The maximum throughput (RU/s) that can be assigned to a container via the Resource Provider during create or update.",
        "display_name": "Max RUs"
    },
    "allowedLinkedServiceResourceTypes": {
        "name": "allowedLinkedServiceResourceTypes",
        "type": "Array",
        "description": "The list of allowed linked service resource types.",
        "display_name": "Allowed linked service resource types",
        "allowed_values": [
            "AdlsGen2CosmosStructuredStream",
            "AdobeExperiencePlatform",
            "AdobeIntegration",
            "AmazonRedshift",
            "AmazonS3",
            "AzureBlobFS",
            "AzureBlobStorage",
            "AzureDataExplorer",
            "AzureDataLakeStore",
            "AzureDataLakeStoreCosmosStructuredStream",
            "AzureDataShare",
            "AzureFileStorage",
            "AzureKeyVault",
            "AzureMariaDB",
            "AzureMySql",
            "AzurePostgreSql",
            "AzureSearch",
            "AzureSqlDatabase",
            "AzureSqlDW",
            "AzureSqlMI",
            "AzureTableStorage",
            "Cassandra",
            "CommonDataServiceForApps",
            "CosmosDb",
            "CosmosDbMongoDbApi",
            "Db2",
            "DynamicsCrm",
            "FileServer",
            "FtpServer",
            "GitHub",
            "GoogleCloudStorage",
            "Hdfs",
            "Hive",
            "HttpServer",
            "Informix",
            "Kusto",
            "MicrosoftAccess",
            "MySql",
            "Netezza",
            "Odata",
            "Odbc",
            "Office365",
            "Oracle",
            "PostgreSql",
            "Salesforce",
            "SalesforceServiceCloud",
            "SapBw",
            "SapHana",
            "SapOpenHub",
            "SapTable",
            "Sftp",
            "SharePointOnlineList",
            "Snowflake",
            "SqlServer",
            "Sybase",
            "Teradata",
            "HDInsightOnDemand",
            "HDInsight",
            "AzureDataLakeAnalytics",
            "AzureBatch",
            "AzureFunction",
            "AzureML",
            "AzureMLService",
            "MongoDb",
            "GoogleBigQuery",
            "Impala",
            "ServiceNow",
            "Dynamics",
            "AzureDatabricks",
            "AmazonMWS",
            "SapCloudForCustomer",
            "SapEcc",
            "Web",
            "MongoDbAtlas",
            "HBase",
            "Spark",
            "Phoenix",
            "PayPal",
            "Marketo",
            "Responsys",
            "SalesforceMarketingCloud",
            "Presto",
            "Square",
            "Xero",
            "Jira",
            "Magento",
            "Shopify",
            "Concur",
            "Hubspot",
            "Zoho",
            "Eloqua",
            "QuickBooks",
            "Couchbase",
            "Drill",
            "Greenplum",
            "MariaDB",
            "Vertica",
            "MongoDbV2",
            "OracleServiceCloud",
            "GoogleAdWords",
            "RestService",
            "DynamicsAX",
            "AzureDataCatalog",
            "AzureDatabricksDeltaLake"
        ]
    },
    "listOfResourceTypesAllowed": {
        "name": "listOfResourceTypesAllowed",
        "type": "Array",
        "description": "The list of resource types that can be deployed.",
        "display_name": "Allowed resource types",
        "strong_type": "resourceTypes"
    },
    "listOfResourceTypesNotAllowed": {
        "name": "listOfResourceTypesNotAllowed",
        "type": "Array",
        "description": "The list of resource types that cannot be deployed.",
        "display_name": "Not allowed resource types",
        "strong_type": "resourceTypes"
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
    "ApplicationName": {
        "name": "ApplicationName",
        "type": "string",
        "description": "A semicolon-separated list of the names of the applications that should not be installed. e.g. 'Microsoft SQL Server 2014 (64-bit); Microsoft Visual Studio Code' or 'Microsoft SQL Server 2014*' (to match any application starting with 'Microsoft SQL Server 2014')",
        "display_name": "Application names (supports wildcards)"
    },
    "MembersToInclude": {
        "name": "MembersToInclude",
        "type": "string",
        "description": "A semicolon-separated list of members that should be included in the Administrators local group. Ex: Administrator; myUser1; myUser2",
        "display_name": "Members to include"
    },
    "host": {
        "name": "host",
        "type": "string",
        "description": "Specifies the Domain Name System (DNS) name or IP address of the remote host machine.",
        "display_name": "Remote Host Name"
    },
    "port": {
        "name": "port",
        "type": "string",
        "description": "The TCP port number on the remote host name.",
        "display_name": "Port"
    },
    "shouldConnect": {
        "name": "shouldConnect",
        "type": "string",
        "description": "The machine will be non-compliant if it can't establish a connection.",
        "display_name": "Should connect to remote host",
        "default_value": "False",
        "allowed_values": [
            "True",
            "False"
        ]
    },
    "WorkspaceId": {
        "name": "WorkspaceId",
        "type": "string",
        "description": "A semicolon-separated list of the workspace IDs that the Log Analytics agent should be connected to",
        "display_name": "Connected workspace IDs"
    },
    "ServiceName": {
        "name": "ServiceName",
        "type": "string",
        "description": "A semicolon-separated list of the names of the services that should be installed and 'Running'. e.g. 'WinRm;Wi*'",
        "display_name": "Service names (supports wildcards)"
    },
    "DomainName": {
        "name": "DomainName",
        "type": "string",
        "description": "The fully qualified domain name (FQDN) that the Windows machines should be joined to",
        "display_name": "Domain Name (FQDN)"
    },
    "TimeZone": {
        "name": "TimeZone",
        "type": "string",
        "description": "The expected time zone",
        "display_name": "Time zone",
        "allowed_values": [
            "(UTC-12:00) International Date Line West",
            "(UTC-11:00) Coordinated Universal Time-11",
            "(UTC-10:00) Aleutian Islands",
            "(UTC-10:00) Hawaii",
            "(UTC-09:30) Marquesas Islands",
            "(UTC-09:00) Alaska",
            "(UTC-09:00) Coordinated Universal Time-09",
            "(UTC-08:00) Baja California",
            "(UTC-08:00) Coordinated Universal Time-08",
            "(UTC-08:00) Pacific Time (US & Canada)",
            "(UTC-07:00) Arizona",
            "(UTC-07:00) Chihuahua, La Paz, Mazatlan",
            "(UTC-07:00) Mountain Time (US & Canada)",
            "(UTC-06:00) Central America",
            "(UTC-06:00) Central Time (US & Canada)",
            "(UTC-06:00) Easter Island",
            "(UTC-06:00) Guadalajara, Mexico City, Monterrey",
            "(UTC-06:00) Saskatchewan",
            "(UTC-05:00) Bogota, Lima, Quito, Rio Branco",
            "(UTC-05:00) Chetumal",
            "(UTC-05:00) Eastern Time (US & Canada)",
            "(UTC-05:00) Haiti",
            "(UTC-05:00) Havana",
            "(UTC-05:00) Indiana (East)",
            "(UTC-05:00) Turks and Caicos",
            "(UTC-04:00) Asuncion",
            "(UTC-04:00) Atlantic Time (Canada)",
            "(UTC-04:00) Caracas",
            "(UTC-04:00) Cuiaba",
            "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan",
            "(UTC-04:00) Santiago",
            "(UTC-03:30) Newfoundland",
            "(UTC-03:00) Araguaina",
            "(UTC-03:00) Brasilia",
            "(UTC-03:00) Cayenne, Fortaleza",
            "(UTC-03:00) City of Buenos Aires",
            "(UTC-03:00) Greenland",
            "(UTC-03:00) Montevideo",
            "(UTC-03:00) Punta Arenas",
            "(UTC-03:00) Saint Pierre and Miquelon",
            "(UTC-03:00) Salvador",
            "(UTC-02:00) Coordinated Universal Time-02",
            "(UTC-02:00) Mid-Atlantic - Old",
            "(UTC-01:00) Azores",
            "(UTC-01:00) Cabo Verde Is.",
            "(UTC) Coordinated Universal Time",
            "(UTC+00:00) Dublin, Edinburgh, Lisbon, London",
            "(UTC+00:00) Monrovia, Reykjavik",
            "(UTC+00:00) Sao Tome",
            "(UTC+01:00) Casablanca",
            "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
            "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague",
            "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris",
            "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb",
            "(UTC+01:00) West Central Africa",
            "(UTC+02:00) Amman",
            "(UTC+02:00) Athens, Bucharest",
            "(UTC+02:00) Beirut",
            "(UTC+02:00) Cairo",
            "(UTC+02:00) Chisinau",
            "(UTC+02:00) Damascus",
            "(UTC+02:00) Gaza, Hebron",
            "(UTC+02:00) Harare, Pretoria",
            "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius",
            "(UTC+02:00) Jerusalem",
            "(UTC+02:00) Kaliningrad",
            "(UTC+02:00) Khartoum",
            "(UTC+02:00) Tripoli",
            "(UTC+02:00) Windhoek",
            "(UTC+03:00) Baghdad",
            "(UTC+03:00) Istanbul",
            "(UTC+03:00) Kuwait, Riyadh",
            "(UTC+03:00) Minsk",
            "(UTC+03:00) Moscow, St. Petersburg",
            "(UTC+03:00) Nairobi",
            "(UTC+03:30) Tehran",
            "(UTC+04:00) Abu Dhabi, Muscat",
            "(UTC+04:00) Astrakhan, Ulyanovsk",
            "(UTC+04:00) Baku",
            "(UTC+04:00) Izhevsk, Samara",
            "(UTC+04:00) Port Louis",
            "(UTC+04:00) Saratov",
            "(UTC+04:00) Tbilisi",
            "(UTC+04:00) Volgograd",
            "(UTC+04:00) Yerevan",
            "(UTC+04:30) Kabul",
            "(UTC+05:00) Ashgabat, Tashkent",
            "(UTC+05:00) Ekaterinburg",
            "(UTC+05:00) Islamabad, Karachi",
            "(UTC+05:00) Qyzylorda",
            "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
            "(UTC+05:30) Sri Jayawardenepura",
            "(UTC+05:45) Kathmandu",
            "(UTC+06:00) Astana",
            "(UTC+06:00) Dhaka",
            "(UTC+06:00) Omsk",
            "(UTC+06:30) Yangon (Rangoon)",
            "(UTC+07:00) Bangkok, Hanoi, Jakarta",
            "(UTC+07:00) Barnaul, Gorno-Altaysk",
            "(UTC+07:00) Hovd",
            "(UTC+07:00) Krasnoyarsk",
            "(UTC+07:00) Novosibirsk",
            "(UTC+07:00) Tomsk",
            "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi",
            "(UTC+08:00) Irkutsk",
            "(UTC+08:00) Kuala Lumpur, Singapore",
            "(UTC+08:00) Perth",
            "(UTC+08:00) Taipei",
            "(UTC+08:00) Ulaanbaatar",
            "(UTC+08:45) Eucla",
            "(UTC+09:00) Chita",
            "(UTC+09:00) Osaka, Sapporo, Tokyo",
            "(UTC+09:00) Pyongyang",
            "(UTC+09:00) Seoul",
            "(UTC+09:00) Yakutsk",
            "(UTC+09:30) Adelaide",
            "(UTC+09:30) Darwin",
            "(UTC+10:00) Brisbane",
            "(UTC+10:00) Canberra, Melbourne, Sydney",
            "(UTC+10:00) Guam, Port Moresby",
            "(UTC+10:00) Hobart",
            "(UTC+10:00) Vladivostok",
            "(UTC+10:30) Lord Howe Island",
            "(UTC+11:00) Bougainville Island",
            "(UTC+11:00) Chokurdakh",
            "(UTC+11:00) Magadan",
            "(UTC+11:00) Norfolk Island",
            "(UTC+11:00) Sakhalin",
            "(UTC+11:00) Solomon Is., New Caledonia",
            "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky",
            "(UTC+12:00) Auckland, Wellington",
            "(UTC+12:00) Coordinated Universal Time+12",
            "(UTC+12:00) Fiji",
            "(UTC+12:00) Petropavlovsk-Kamchatsky - Old",
            "(UTC+12:45) Chatham Islands",
            "(UTC+13:00) Coordinated Universal Time+13",
            "(UTC+13:00) Nuku'alofa",
            "(UTC+13:00) Samoa",
            "(UTC+14:00) Kiritimati Island"
        ]
    },
    "CertificateStorePath": {
        "name": "CertificateStorePath",
        "type": "string",
        "description": "The path to the certificate store containing the certificates to check the expiration dates of. Default value is 'Cert:' which is the root certificate store path, so all certificates on the machine will be checked. Other example paths: 'Cert:\\LocalMachine', 'Cert:\\LocalMachine\\TrustedPublisher', 'Cert:\\CurrentUser'",
        "display_name": "Certificate store path",
        "default_value": "Cert:"
    },
    "ExpirationLimitInDays": {
        "name": "ExpirationLimitInDays",
        "type": "string",
        "description": "An integer indicating the number of days within which to check for certificates that are expiring. For example, if this value is 30, any certificate expiring within the next 30 days will cause this policy to be non-compliant.",
        "display_name": "Expiration limit in days",
        "default_value": "30"
    },
    "CertificateThumbprintsToInclude": {
        "name": "CertificateThumbprintsToInclude",
        "type": "string",
        "description": "A semicolon-separated list of certificate thumbprints to check under the specified path. If a value is not specified, all certificates under the certificate store path will be checked. If a value is specified, no certificates other than those with the thumbprints specified will be checked. e.g. THUMBPRINT1;THUMBPRINT2;THUMBPRINT3",
        "display_name": "Certificate thumbprints to include",
        "default_value": ""
    },
    "CertificateThumbprintsToExclude": {
        "name": "CertificateThumbprintsToExclude",
        "type": "string",
        "description": "A semicolon-separated list of certificate thumbprints to ignore. e.g. THUMBPRINT1;THUMBPRINT2;THUMBPRINT3",
        "display_name": "Certificate thumbprints to exclude",
        "default_value": ""
    },
    "IncludeExpiredCertificates": {
        "name": "IncludeExpiredCertificates",
        "type": "string",
        "description": "Must be 'true' or 'false'. True indicates that any found certificates that have already expired will also make this policy non-compliant. False indicates that certificates that have expired will be be ignored.",
        "display_name": "Include expired certificates",
        "default_value": "false",
        "allowed_values": [
            "true",
            "false"
        ]
    },
    "CertificateThumbprints": {
        "name": "CertificateThumbprints",
        "type": "string",
        "description": "A semicolon-separated list of certificate thumbprints that should exist under the Trusted Root certificate store (Cert:\\LocalMachine\\Root). e.g. THUMBPRINT1;THUMBPRINT2;THUMBPRINT3",
        "display_name": "Certificate thumbprints"
    },
    "ExecutionPolicy": {
        "name": "ExecutionPolicy",
        "type": "string",
        "description": "The expected PowerShell execution policy.",
        "display_name": "PowerShell Execution Policy",
        "allowed_values": [
            "AllSigned",
            "Bypass",
            "Default",
            "RemoteSigned",
            "Restricted",
            "Undefined",
            "Unrestricted"
        ]
    },
    "Modules": {
        "name": "Modules",
        "type": "string",
        "description": "A semicolon-separated list of the names of the PowerShell modules that should be installed. You may also specify a specific version of a module that should be installed by including a comma after the module name, followed by the desired version. Example: PSDscResources; SqlServerDsc, 12.0.0.0; ComputerManagementDsc, 6.1.0.0",
        "display_name": "PowerShell Modules"
    },
    "installedApplication": {
        "name": "installedApplication",
        "type": "string",
        "description": "A semicolon-separated list of the names of the applications that should be installed. e.g. 'Microsoft SQL Server 2014 (64-bit); Microsoft Visual Studio Code' or 'Microsoft SQL Server 2014*' (to match any application starting with 'Microsoft SQL Server 2014')",
        "display_name": "Application names (supports wildcards)"
    },
    "MembersToExclude": {
        "name": "MembersToExclude",
        "type": "string",
        "description": "A semicolon-separated list of members that should be excluded in the Administrators local group. Ex: Administrator; myUser1; myUser2",
        "display_name": "Members to exclude"
    },
    "caCommonName": {
        "name": "caCommonName",
        "type": "string",
        "description": "The common name (CN) of the Certificate Authority (CA) provider. For example, for an issuer CN = Contoso, OU = .., DC = .., you can specify Contoso",
        "display_name": "The common name of the certificate authority"
    },
    "maximumPercentageLife": {
        "name": "maximumPercentageLife",
        "type": "Integer",
        "description": "Enter the percentage of lifetime of the certificate when you want to trigger the policy action. For example, to trigger a policy action at 80% of the certificate's valid life, enter '80'.",
        "display_name": "The maximum lifetime percentage"
    },
    "minimumDaysBeforeExpiry": {
        "name": "minimumDaysBeforeExpiry",
        "type": "Integer",
        "description": "Enter the days before expiration of the certificate when you want to trigger the policy action. For example, to trigger a policy action 90 days before the certificate's expiration, enter '90'.",
        "display_name": "The minimum days before expiry"
    },
    "daysToExpire": {
        "name": "daysToExpire",
        "type": "Integer",
        "description": "The number of days for a certificate to expire.",
        "display_name": "Days to expire"
    },
    "minimumRSAKeySize": {
        "name": "minimumRSAKeySize",
        "type": "Integer",
        "description": "The minimum key size for RSA keys.",
        "display_name": "Minimum RSA key size",
        "allowed_values": [
            2048,
            3072,
            4096
        ]
    },
    "minimumDaysBeforeExpiration": {
        "name": "minimumDaysBeforeExpiration",
        "type": "Integer",
        "description": "Specify the minimum number of days that a secret should remain usable prior to expiration.",
        "display_name": "The minimum days before expiration"
    },
    "maximumValidityInDays": {
        "name": "maximumValidityInDays",
        "type": "Integer",
        "description": "Specify the maximum number of days a secret can be valid for after activation.",
        "display_name": "The maximum validity period in days"
    },
    "excludedNamespaces": {
        "name": "excludedNamespaces",
        "type": "Array",
        "description": "List of Kubernetes namespaces to exclude from policy evaluation.",
        "display_name": "Namespace exclusions",
        "default_value": [
            "kube-system",
            "gatekeeper-system",
            "azure-arc"
        ]
    },
    "namespaces": {
        "name": "namespaces",
        "type": "Array",
        "description": "List of Kubernetes namespaces to only include in policy evaluation. An empty list means the policy is applied to all resources in all namespaces.",
        "display_name": "Namespace inclusions",
        "default_value": []
    },
    "labelSelector": {
        "name": "labelSelector",
        "type": "object",
        "description": "Label query to select Kubernetes resources for policy evaluation. An empty label selector matches all Kubernetes resources.",
        "display_name": "Kubernetes label selector"
    },
    "cpuLimit": {
        "name": "cpuLimit",
        "type": "String",
        "description": "The maximum CPU units allowed for a container. E.g. 200m. For more information, please refer https://aka.ms/k8s-policy-pod-limits",
        "display_name": "Max allowed CPU units"
    },
    "memoryLimit": {
        "name": "memoryLimit",
        "type": "String",
        "description": "The maximum memory bytes allowed for a container. E.g. 1Gi. For more information, please refer https://aka.ms/k8s-policy-pod-limits",
        "display_name": "Max allowed memory bytes"
    },
    "forbiddenSysctls": {
        "name": "forbiddenSysctls",
        "type": "Array",
        "description": "The list of plain sysctl names or sysctl patterns which end with *. The string * matches all sysctls. For more information, visit https://aka.ms/k8s-policy-sysctl-interfaces.",
        "display_name": "Forbidden sysctls"
    },
    "allowedContainerPortsList": {
        "name": "allowedContainerPortsList",
        "type": "Array",
        "description": "The list of container ports allowed in a Kubernetes cluster.",
        "display_name": "Allowed container ports list"
    },
    "allowedProfiles": {
        "name": "allowedProfiles",
        "type": "Array",
        "description": "The list of seccomp profiles that containers are allowed to use. E.g. 'runtime/default;docker/default'. Provide empty list as input to block everything.",
        "display_name": "Allowed seccomp profiles",
        "default_value": []
    },
    "procMountType": {
        "name": "procMountType",
        "type": "String",
        "description": "The ProcMountType that containers are allowed to use in the cluster.",
        "display_name": "ProcMountType",
        "default_value": "Default",
        "allowed_values": [
            "Unmasked",
            "Default"
        ]
    },
    "allowedCapabilities": {
        "name": "allowedCapabilities",
        "type": "Array",
        "description": "The list of capabilities that are allowed to be added to a container. Provide empty list as input to block everything.",
        "display_name": "Allowed capabilities",
        "default_value": []
    },
    "requiredDropCapabilities": {
        "name": "requiredDropCapabilities",
        "type": "Array",
        "description": "The list of capabilities that must be dropped by a container.",
        "display_name": "Required drop capabilities",
        "default_value": []
    },
    "allowedContainerImagesRegex": {
        "name": "allowedContainerImagesRegex",
        "type": "String",
        "description": "The RegEx rule used to match allowed container images in a Kubernetes cluster. For example, to allow any Azure Container Registry image by matching partial path: ^.+azurecr.io/.+$",
        "display_name": "Allowed container images regex"
    },
    "allowedFlexVolumeDrivers": {
        "name": "allowedFlexVolumeDrivers",
        "type": "Array",
        "description": "The list of drivers that FlexVolume volumes are allowed to use. Provide empty list as input to block everything.",
        "display_name": "Allowed FlexVolume drivers",
        "default_value": []
    },
    "allowedHostPaths": {
        "name": "allowedHostPaths",
        "type": "Object",
        "description": "The host paths allowed for pod hostPath volumes to use. Provide an empty paths list to block all host paths.",
        "display_name": "Allowed host paths",
        "default_value": {
            "paths": []
        }
    },
    "runAsUserRule": {
        "name": "runAsUserRule",
        "type": "String",
        "description": "The 'RunAsUser' rule that containers are allowed to run with.",
        "display_name": "Run as user rule",
        "default_value": "MustRunAsNonRoot",
        "allowed_values": [
            "MustRunAs",
            "MustRunAsNonRoot",
            "RunAsAny"
        ]
    },
    "runAsUserRanges": {
        "name": "runAsUserRanges",
        "type": "Object",
        "description": "The user ID ranges that are allowed for containers to use.",
        "display_name": "Allowed user ID ranges",
        "default_value": {
            "ranges": []
        }
    },
    "runAsGroupRule": {
        "name": "runAsGroupRule",
        "type": "String",
        "description": "The 'RunAsGroup' rule that containers are allowed to run with.",
        "display_name": "Run as group rule",
        "default_value": "RunAsAny",
        "allowed_values": [
            "MustRunAs",
            "MayRunAs",
            "RunAsAny"
        ]
    },
    "runAsGroupRanges": {
        "name": "runAsGroupRanges",
        "type": "Object",
        "description": "The group ID ranges that are allowed for containers to use.",
        "display_name": "Allowed group ID ranges",
        "default_value": {
            "ranges": []
        }
    },
    "supplementalGroupsRule": {
        "name": "supplementalGroupsRule",
        "type": "String",
        "description": "The 'SupplementalGroups' rule that containers are allowed to run with.",
        "display_name": "Supplemental group rule",
        "default_value": "RunAsAny",
        "allowed_values": [
            "MustRunAs",
            "MayRunAs",
            "RunAsAny"
        ]
    },
    "supplementalGroupsRanges": {
        "name": "supplementalGroupsRanges",
        "type": "Object",
        "description": "The supplemental group ID ranges that are allowed for containers to use.",
        "display_name": "Allowed supplemental group ID ranges",
        "default_value": {
            "ranges": []
        }
    },
    "fsGroupRule": {
        "name": "fsGroupRule",
        "type": "String",
        "description": "The 'FSGroup' rule that containers are allowed to run with.",
        "display_name": "File system group rule",
        "default_value": "RunAsAny",
        "allowed_values": [
            "MustRunAs",
            "MayRunAs",
            "RunAsAny"
        ]
    },
    "fsGroupRanges": {
        "name": "fsGroupRanges",
        "type": "Object",
        "description": "The file system group ranges that are allowed for pods to use.",
        "display_name": "Allowed file system group ID ranges",
        "default_value": {
            "ranges": []
        }
    },
    "allowedSELinuxOptions": {
        "name": "allowedSELinuxOptions",
        "type": "Object",
        "description": "The allowed configurations for pod and container level SELinux Options. Provide empty options list as input to block everything.",
        "display_name": "Allowed SELinux options",
        "default_value": {
            "options": []
        }
    },
    "allowedVolumeTypes": {
        "name": "allowedVolumeTypes",
        "type": "Array",
        "description": "The list of volume types that can be used by a pod. Provide empty list as input to block everything.",
        "display_name": "Allowed volume types",
        "default_value": []
    },
    "allowHostNetwork": {
        "name": "allowHostNetwork",
        "type": "Boolean",
        "description": "Set this value to true if pod is allowed to use host network otherwise false.",
        "display_name": "Allow host network usage"
    },
    "minPort": {
        "name": "minPort",
        "type": "Integer",
        "description": "The minimum value in the allowable host port range that pods can use in the host network namespace.",
        "display_name": "Min host port"
    },
    "maxPort": {
        "name": "maxPort",
        "type": "Integer",
        "description": "The maximum value in the allowable host port range that pods can use in the host network namespace.",
        "display_name": "Max host port"
    },
    "labelsList": {
        "name": "labelsList",
        "type": "Array",
        "description": "The list of labels to be specified on Pods in a Kubernetes cluster.",
        "display_name": "List of labels"
    },
    "allowedServicePortsList": {
        "name": "allowedServicePortsList",
        "type": "Array",
        "description": "The list of service ports allowed in a Kubernetes cluster.",
        "display_name": "Allowed service ports list"
    },
    "allowedExternalIPs": {
        "name": "allowedExternalIPs",
        "type": "Array",
        "description": "List of External IPs that services are allowed to use. Empty array means all external IPs are disallowed.",
        "display_name": "Allowed External IPs",
        "default_value": []
    },
    "disallowedCapabilities": {
        "name": "disallowedCapabilities",
        "type": "Array",
        "description": "List of capabilities that containers are not able to use",
        "display_name": "Blocked capabilities",
        "default_value": []
    },
    "listOfAllowedTenants": {
        "name": "listOfAllowedTenants",
        "type": "Array",
        "description": "List of the tenants IDs that can be onboarded through Azure Lighthouse",
        "display_name": "Allowed tenants"
    },
    "computeNames": {
        "name": "computeNames",
        "type": "Array",
        "description": "List of compute names where this policy should be applied. Ex. cpu-cluster;gpu-cluster. If no value is provided to this parameter then policy is applicable to all computes.",
        "display_name": "Compute names where Azure ML jobs run",
        "default_value": []
    },
    "allowedPythonPackageChannels": {
        "name": "allowedPythonPackageChannels",
        "type": "Array",
        "description": "List of allowed Python package indexes. Ex. http://somepythonindex.org ",
        "display_name": "Allowed Python package indexes",
        "default_value": []
    },
    "allowedModuleAuthors": {
        "name": "allowedModuleAuthors",
        "type": "Array",
        "description": "List of allowed module authors.",
        "display_name": "Allowed module authors",
        "default_value": []
    },
    "allowedACRs": {
        "name": "allowedACRs",
        "type": "Array",
        "description": "List of Azure Container Registries that can be used with Azure ML. Ex. amlrepo.azurecr.io;amlrepo.azurecr.io/foo",
        "display_name": "Azure Container Registries",
        "default_value": []
    },
    "approvalEndpoint": {
        "name": "approvalEndpoint",
        "type": "String",
        "description": "Approval endpoint that needs to be called before an Azure ML job is run. Ex. http://amlrunapproval/approve",
        "display_name": "Approval endpoint"
    },
    "signingKey": {
        "name": "signingKey",
        "type": "String",
        "description": "Public key text in PGP public key format, with newline characters encoded as string literals \"\\r\" and \"\\n\".",
        "display_name": "PGP public key"
    },
    "logFilters": {
        "name": "logFilters",
        "type": "Array",
        "description": "List of log filter expressions used to filter logs. Ex. ^prefix1.*$",
        "display_name": "Log filter expressions",
        "default_value": []
    },
    "datastore": {
        "name": "datastore",
        "type": "String",
        "description": "Datastore used to store filtered logs. Ex. LogsDatastore which is configured in AML.",
        "display_name": "Datastore"
    },
    "operationName": {
        "name": "operationName",
        "type": "String",
        "description": "Security Operation name for which activity log alert should exist",
        "display_name": "Operation Name",
        "allowed_values": [
            "Microsoft.Security/policies/write",
            "Microsoft.Security/securitySolutions/write",
            "Microsoft.Security/securitySolutions/delete"
        ]
    },
    "logAnalyticsWorkspaceId": {
        "name": "logAnalyticsWorkspaceId",
        "type": "String",
        "description": "This is the Id (GUID) of the Log Analytics Workspace that the VMs should be configured for.",
        "display_name": "Log Analytics Workspace Id that VMs should be configured for"
    },
    "listOfResourceTypes": {
        "name": "listOfResourceTypes",
        "type": "Array",
        "description": null,
        "display_name": "Resource Types",
        "strong_type": "resourceTypes"
    },
    "listOfImageIdToInclude_windows": {
        "name": "listOfImageIdToInclude_windows",
        "type": "Array",
        "description": "Example value: '/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Compute/images/ContosoStdImage'",
        "display_name": "Optional: List of virtual machine images that have supported Windows OS to add to scope",
        "default_value": []
    },
    "listOfImageIdToInclude_linux": {
        "name": "listOfImageIdToInclude_linux",
        "type": "Array",
        "description": "Example value: '/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Compute/images/ContosoStdImage'",
        "display_name": "Optional: List of virtual machine images that have supported Linux OS to add to scope",
        "default_value": []
    },
    "IPsecEncryption": {
        "name": "IPsecEncryption",
        "type": "Array",
        "description": "IPsec Encryption",
        "display_name": "IPsec Encryption"
    },
    "IPsecIntegrity": {
        "name": "IPsecIntegrity",
        "type": "Array",
        "description": "IPsec Integrity",
        "display_name": "IPsec Integrity"
    },
    "IKEEncryption": {
        "name": "IKEEncryption",
        "type": "Array",
        "description": "IKE Encryption",
        "display_name": "IKE Encryption"
    },
    "IKEIntegrity": {
        "name": "IKEIntegrity",
        "type": "Array",
        "description": "IKE Integrity",
        "display_name": "IKE Integrity"
    },
    "DHGroup": {
        "name": "DHGroup",
        "type": "Array",
        "description": "DH Group",
        "display_name": "DH Group"
    },
    "PFSGroup": {
        "name": "PFSGroup",
        "type": "Array",
        "description": "PFS Group",
        "display_name": "PFS Group"
    },
    "listOfLocations": {
        "name": "listOfLocations",
        "type": "Array",
        "description": "Audit if Network Watcher is not enabled for region(s).",
        "display_name": "Locations",
        "strong_type": "location"
    },
    "resourceGroupName": {
        "name": "resourceGroupName",
        "type": "String",
        "description": "Name of the resource group of NetworkWatcher, such as NetworkWatcherRG. This is the resource group where the Network Watchers are located.",
        "display_name": "NetworkWatcher resource group name",
        "default_value": "NetworkWatcherRG"
    },
    "virtualNetworkId": {
        "name": "virtualNetworkId",
        "type": "string",
        "description": "Resource Id of the virtual network. Example: /subscriptions/YourSubscriptionId/resourceGroups/YourResourceGroupName/providers/Microsoft.Network/virtualNetworks/Name",
        "display_name": "Virtual network Id"
    },
    "virtualNetworkGatewayId": {
        "name": "virtualNetworkGatewayId",
        "type": "string",
        "description": "Resource Id of the virtual network gateway. Example: /subscriptions/YourSubscriptionId/resourceGroups/YourResourceGroup/providers/Microsoft.Network/virtualNetworkGateways/Name",
        "display_name": "Virtual network gateway Id"
    },
    "subnetId": {
        "name": "subnetId",
        "type": "string",
        "description": "The resource ID of the virtual network subnet that should have a rule enabled. Example: /subscriptions/00000000-1111-2222-3333-444444444444/resourceGroups/Default/providers/Microsoft.Network/virtualNetworks/testvnet/subnets/testsubnet",
        "display_name": "Subnet ID",
        "strong_type": "Microsoft.Network/virtualNetworks/subnets"
    },
    "allowedTenantIds": {
        "name": "allowedTenantIds",
        "type": "Array",
        "description": "This parameter defines the list of Allowed Tenant Ids that are allowed to create managed private endpoints in the workspaces",
        "display_name": "List of Allowed Tenant Ids for private endpoint creation",
        "default_value": []
    },
    "tagName": {
        "name": "tagName",
        "type": "String",
        "description": "Name of the tag, such as 'environment'",
        "display_name": "Tag Name"
    },
    "tagValue": {
        "name": "tagValue",
        "type": "String",
        "description": "Value of the tag, such as 'production'",
        "display_name": "Tag Value"
    }
}
PARAMETERS
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "example_params_required" {
  name                 = local.name_example_params_required
  policy_definition_id = azurerm_policy_set_definition.example_params_required.id
  scope                = local.scope
  enforcement_mode     = local.enforcement_mode_example_params_required
  parameters = jsonencode({
    metricName = { "value" = null }
	listOfAllowedSKUs = { "value" = null }
	allowedEncryptionSets = { "value" = null }
	approvedExtensions = { "value" = null }
	includeAKSClusters = { "value" = null }
	listOfAllowedLocations = { "value" = null }
	policyEffect = { "value" = "deny" }
	throughputMax = { "value" = null }
	allowedLinkedServiceResourceTypes = { "value" = null }
	listOfResourceTypesAllowed = { "value" = null }
	listOfResourceTypesNotAllowed = { "value" = null }
	IncludeArcMachines = { "value" = "false" }
	ApplicationName = { "value" = null }
	MembersToInclude = { "value" = null }
	host = { "value" = null }
	port = { "value" = null }
	shouldConnect = { "value" = "False" }
	WorkspaceId = { "value" = null }
	ServiceName = { "value" = null }
	DomainName = { "value" = null }
	TimeZone = { "value" = null }
	CertificateStorePath = { "value" = "Cert:" }
	ExpirationLimitInDays = { "value" = "30" }
	CertificateThumbprintsToInclude = { "value" = "" }
	CertificateThumbprintsToExclude = { "value" = "" }
	IncludeExpiredCertificates = { "value" = "false" }
	CertificateThumbprints = { "value" = null }
	ExecutionPolicy = { "value" = null }
	Modules = { "value" = null }
	installedApplication = { "value" = null }
	MembersToExclude = { "value" = null }
	caCommonName = { "value" = null }
	maximumPercentageLife = { "value" = null }
	minimumDaysBeforeExpiry = { "value" = null }
	daysToExpire = { "value" = null }
	minimumRSAKeySize = { "value" = null }
	minimumDaysBeforeExpiration = { "value" = null }
	maximumValidityInDays = { "value" = null }
	excludedNamespaces = { "value" = ["kube-system", "gatekeeper-system", "azure-arc"] }
	namespaces = { "value" = [] }
	labelSelector = { "value" = null }
	cpuLimit = { "value" = null }
	memoryLimit = { "value" = null }
	forbiddenSysctls = { "value" = null }
	allowedContainerPortsList = { "value" = null }
	allowedProfiles = { "value" = [] }
	procMountType = { "value" = "Default" }
	allowedCapabilities = { "value" = [] }
	requiredDropCapabilities = { "value" = [] }
	allowedContainerImagesRegex = { "value" = null }
	allowedFlexVolumeDrivers = { "value" = [] }
	allowedHostPaths = { "value" = {"paths": []} }
	runAsUserRule = { "value" = "MustRunAsNonRoot" }
	runAsUserRanges = { "value" = {"ranges": []} }
	runAsGroupRule = { "value" = "RunAsAny" }
	runAsGroupRanges = { "value" = {"ranges": []} }
	supplementalGroupsRule = { "value" = "RunAsAny" }
	supplementalGroupsRanges = { "value" = {"ranges": []} }
	fsGroupRule = { "value" = "RunAsAny" }
	fsGroupRanges = { "value" = {"ranges": []} }
	allowedSELinuxOptions = { "value" = {"options": []} }
	allowedVolumeTypes = { "value" = [] }
	allowHostNetwork = { "value" = null }
	minPort = { "value" = null }
	maxPort = { "value" = null }
	labelsList = { "value" = null }
	allowedServicePortsList = { "value" = null }
	allowedExternalIPs = { "value" = [] }
	disallowedCapabilities = { "value" = [] }
	listOfAllowedTenants = { "value" = null }
	computeNames = { "value" = [] }
	allowedPythonPackageChannels = { "value" = [] }
	allowedModuleAuthors = { "value" = [] }
	allowedACRs = { "value" = [] }
	approvalEndpoint = { "value" = null }
	signingKey = { "value" = null }
	logFilters = { "value" = [] }
	datastore = { "value" = null }
	operationName = { "value" = null }
	logAnalyticsWorkspaceId = { "value" = null }
	listOfResourceTypes = { "value" = null }
	listOfImageIdToInclude_windows = { "value" = [] }
	listOfImageIdToInclude_linux = { "value" = [] }
	IPsecEncryption = { "value" = null }
	IPsecIntegrity = { "value" = null }
	IKEEncryption = { "value" = null }
	IKEIntegrity = { "value" = null }
	DHGroup = { "value" = null }
	PFSGroup = { "value" = null }
	listOfLocations = { "value" = null }
	resourceGroupName = { "value" = "NetworkWatcherRG" }
	virtualNetworkId = { "value" = null }
	virtualNetworkGatewayId = { "value" = null }
	subnetId = { "value" = null }
	allowedTenantIds = { "value" = [] }
	tagName = { "value" = null }
	tagValue = { "value" = null }
})
}


# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "example_params_required_policy_assignment_ids" {
  value       = azurerm_policy_assignment.example_params_required.id
  description = "The IDs of the Policy Assignments."
}

output "example_params_required_scope" {
  value       = local.scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "example_params_required_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.example_params_required.id
  description = "The ID of the Policy Set Definition."
}

