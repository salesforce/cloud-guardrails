variable "name" { default = "example" }
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
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "Do not allow privileged containers in Kubernetes cluster",
    "Enforce internal load balancers in Kubernetes cluster",
    "Kubernetes cluster containers should not share host process ID or host IPC namespace",
    "Kubernetes cluster containers should only use allowed AppArmor profiles",
    "Kubernetes cluster containers should only use allowed ProcMountType",
    "Kubernetes cluster containers should only use allowed capabilities",
    "Kubernetes cluster containers should only use allowed seccomp profiles",
    "Kubernetes cluster containers should run with a read only root file system",
    "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers",
    "Kubernetes cluster pod hostPath volumes should only use allowed host paths",
    "Kubernetes cluster pods and containers should only run with approved user and group IDs",
    "Kubernetes cluster pods and containers should only use allowed SELinux options",
    "Kubernetes cluster pods should only use allowed volume types",
    "Kubernetes clusters should be accessible only over HTTPS",
    "Kubernetes clusters should not allow container privilege escalation",
    "[Preview]: Kubernetes cluster services should only use allowed external IPs",
    "[Preview]: Kubernetes clusters should disable automounting API credentials",
    "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities",
    "[Preview]: Kubernetes clusters should not use specific security capabilities",
    "[Preview]: Kubernetes clusters should not use the default namespace",
  ]
  policy_definition_map = zipmap(
    data.azurerm_policy_definition.definition_lookups.*.display_name,
    data.azurerm_policy_definition.definition_lookups.*.id
  )
}

data "azurerm_policy_definition" "definition_lookups" {
  count        = length(local.policy_names)
  display_name = local.policy_names[count.index]
}

resource "azurerm_policy_set_definition" "guardrails" {
  name                  = var.name
  policy_type           = "Custom"
  display_name          = var.name
  description           = var.name
  management_group_name = var.management_group == "" ? null : var.management_group
  metadata = tostring(jsonencode({
    category = var.category
  }))


  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Do not allow privileged containers in Kubernetes cluster")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Enforce internal load balancers in Kubernetes cluster")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should not share host process ID or host IPC namespace")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed AppArmor profiles")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedProfiles = { "value" : "[parameters('allowedProfiles')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed ProcMountType")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      procMountType = { "value" : "[parameters('procMountType')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed capabilities")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedCapabilities = { "value" : "[parameters('allowedCapabilities')]" }
      requiredDropCapabilities = { "value" : "[parameters('requiredDropCapabilities')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should only use allowed seccomp profiles")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedProfiles = { "value" : "[parameters('allowedProfiles')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster containers should run with a read only root file system")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedFlexVolumeDrivers = { "value" : "[parameters('allowedFlexVolumeDrivers')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pod hostPath volumes should only use allowed host paths")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedHostPaths = { "value" : "[parameters('allowedHostPaths')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods and containers should only run with approved user and group IDs")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
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
      allowedSELinuxOptions = { "value" : "[parameters('allowedSELinuxOptions')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes cluster pods should only use allowed volume types")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedVolumeTypes = { "value" : "[parameters('allowedVolumeTypes')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should be accessible only over HTTPS")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Kubernetes clusters should not allow container privilege escalation")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes cluster services should only use allowed external IPs")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      allowedExternalIPs = { "value" : "[parameters('allowedExternalIPs')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should disable automounting API credentials")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use specific security capabilities")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
      disallowedCapabilities = { "value" : "[parameters('disallowedCapabilities')]" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "[Preview]: Kubernetes clusters should not use the default namespace")
    parameter_values = jsonencode({
      excludedNamespaces = { "value" : "[parameters('excludedNamespaces')]" }
      namespaces = { "value" : "[parameters('namespaces')]" }
    })
    reference_id = null
  }


  parameters = <<PARAMETERS
{
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
    }
}
PARAMETERS
}


output "id" {
  value = azurerm_policy_set_definition.guardrails.id
}