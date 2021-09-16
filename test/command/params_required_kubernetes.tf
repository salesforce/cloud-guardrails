locals {
  name_example_PR_Audit = "example_PR_Audit"
  subscription_name_example_PR_Audit = "example"
  management_group_example_PR_Audit = ""
  category_example_PR_Audit = "Testing"
  enforcement_mode_example_PR_Audit = false
  policy_ids_example_PR_Audit = [
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
    "d46c275d-1680-448d-b2ec-e495a3b6cc89", # Kubernetes cluster services should only use allowed external IPs 
    "95edb821-ddaf-4404-9732-666045e056b4", # Kubernetes cluster should not allow privileged containers 
    "1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d", # Kubernetes clusters should be accessible only over HTTPS 
    "423dd1ba-798e-40e4-9c4d-b6902674b423", # Kubernetes clusters should disable automounting API credentials 
    "1c6e92c9-99f0-4e55-9cf2-0c234dc48f99", # Kubernetes clusters should not allow container privilege escalation 
    "d2e7ea85-6b44-4317-a0be-1b951587f626", # Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities 
    "a27c700f-8a22-44ec-961c-41625264370b", # Kubernetes clusters should not use specific security capabilities 
    "9f061a12-e40d-4183-a00e-171812443373", # Kubernetes clusters should not use the default namespace 
    "3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e", # Kubernetes clusters should use internal load balancers 
    
  ]
  policy_definition_map = {
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
    "Kubernetes cluster services should only use allowed external IPs" = "/providers/Microsoft.Authorization/policyDefinitions/d46c275d-1680-448d-b2ec-e495a3b6cc89",
    "Kubernetes cluster should not allow privileged containers" = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4",
    "Kubernetes clusters should be accessible only over HTTPS" = "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d",
    "Kubernetes clusters should disable automounting API credentials" = "/providers/Microsoft.Authorization/policyDefinitions/423dd1ba-798e-40e4-9c4d-b6902674b423",
    "Kubernetes clusters should not allow container privilege escalation" = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99",
    "Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities" = "/providers/Microsoft.Authorization/policyDefinitions/d2e7ea85-6b44-4317-a0be-1b951587f626",
    "Kubernetes clusters should not use specific security capabilities" = "/providers/Microsoft.Authorization/policyDefinitions/a27c700f-8a22-44ec-961c-41625264370b",
    "Kubernetes clusters should not use the default namespace" = "/providers/Microsoft.Authorization/policyDefinitions/9f061a12-e40d-4183-a00e-171812443373",
    "Kubernetes clusters should use internal load balancers" = "/providers/Microsoft.Authorization/policyDefinitions/3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e",
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
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster services should only use allowed external IPs")
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
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster should not allow privileged containers")
    parameter_values = jsonencode({
        effect = { "value" : "deny" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
        excludedContainers = { "value" : [] }
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
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should disable automounting API credentials")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
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
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities")
    parameter_values = jsonencode({
        effect = { "value" : "audit" }
        excludedNamespaces = { "value" : ["kube-system", "gatekeeper-system", "azure-arc"] }
        namespaces = { "value" : [] }
        labelSelector = { "value" : {} }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not use specific security capabilities")
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
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not use the default namespace")
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