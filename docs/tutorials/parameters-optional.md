# Parameters Optional Tutorial


* Generate the parameters file:

```bash
cloud-guardrails create-parameters-file \
    --optional-only \
    -o parameters-optional.yml
```

The generated `parameters-optional.yml` file will only contain policies that have parameters with default values. The policies are sorted by service for improved readability. Consider the snippet below from the Key Vault section:

```yaml
# ---------------------------------------------------------------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------------------------------------------------------------
Key Vault:
  "Resource logs in Key Vault should be enabled":
    effect: AuditIfNotExists  # Allowed: ["AuditIfNotExists", "Disabled"]
    requiredRetentionDays: 365

  "[Preview]: Certificates should be issued by the specified integrated certificate authority":
    allowedCAs:
        - DigiCert
        - GlobalSign # Allowed: ["DigiCert", "GlobalSign"]
    effect: audit  # Allowed: ["audit", "deny", "disabled"]

  "[Preview]: Certificates should have the specified maximum validity period":
    maximumValidityInMonths: 12
    effect: audit  # Allowed: ["audit", "deny", "disabled"]
```

Notice how some parameters only allow specific values. For example, the policy named `"Certificates should be issued by the specified integrated certificate authority"` has a parameter called `allowedCAs`. However, you can't just provide **any** value to that parameter - it has to be one of two allowed values. `cloud-guardrails` simplifies this process by including the allowed values in the comments - `# Allowed: ["DigiCert", "GlobalSign"]`.


* Now let's generate Terraform using this parameters file. Run the following command:

```bash
cloud-guardrails generate-terraform --params-optional \
    -s "Key Vault" \
    --subscription example \
    -p parameters-optional.yml
```

* Observe that the output will include the parameters that you supplied in your config file:

<details>
<summary>Click to expand!</summary>
<p>

```hcl
locals {
  name_example_PO_Audit = "example_PO_Audit"
  subscription_name_example_PO_Audit = "example"
  management_group_example_PO_Audit = ""
  category_example_PO_Audit = "Testing"
  enforcement_mode_example_PO_Audit = false
  policy_ids_example_PO_Audit = [
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "a2a5b911-5617-447e-a49e-59dbe0e0434b", # Resource logs in Azure Key Vault Managed HSM should be enabled
    "cf820ca0-f99e-4f3e-84fb-66e913812d21", # Resource logs in Key Vault should be enabled
    "8e826246-c976-48f6-b03e-619bb92b3d82", # Certificates should be issued by the specified integrated certificate authority
    "0a075868-4c26-42ef-914c-5bc007359560", # Certificates should have the specified maximum validity period
    "1151cede-290b-4ba0-8b38-0ad145ac888f", # Certificates should use allowed key types
    "bd78111f-4953-4367-9fd5-7e08808b54bf", # Certificates using elliptic curve cryptography should have allowed curve names
    "75c4f823-d65c-4f29-a733-01d0077fdbcb", # Keys should be the specified cryptographic type RSA or EC
    "ff25f3c8-b739-4538-9d07-3d6d25cfb255", # Keys using elliptic curve cryptography should have the specified curve names

  ]
  policy_definition_map = {
    "Resource logs in Azure Key Vault Managed HSM should be enabled" = "/providers/Microsoft.Authorization/policyDefinitions/a2a5b911-5617-447e-a49e-59dbe0e0434b",
    "Resource logs in Key Vault should be enabled" = "/providers/Microsoft.Authorization/policyDefinitions/cf820ca0-f99e-4f3e-84fb-66e913812d21",
    "Certificates should be issued by the specified integrated certificate authority" = "/providers/Microsoft.Authorization/policyDefinitions/8e826246-c976-48f6-b03e-619bb92b3d82",
    "Certificates should have the specified maximum validity period" = "/providers/Microsoft.Authorization/policyDefinitions/0a075868-4c26-42ef-914c-5bc007359560",
    "Certificates should use allowed key types" = "/providers/Microsoft.Authorization/policyDefinitions/1151cede-290b-4ba0-8b38-0ad145ac888f",
    "Certificates using elliptic curve cryptography should have allowed curve names" = "/providers/Microsoft.Authorization/policyDefinitions/bd78111f-4953-4367-9fd5-7e08808b54bf",
    "Keys should be the specified cryptographic type RSA or EC" = "/providers/Microsoft.Authorization/policyDefinitions/75c4f823-d65c-4f29-a733-01d0077fdbcb",
    "Keys using elliptic curve cryptography should have the specified curve names" = "/providers/Microsoft.Authorization/policyDefinitions/ff25f3c8-b739-4538-9d07-3d6d25cfb255",
    }
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
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Azure Key Vault Managed HSM should be enabled")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        requiredRetentionDays = { "value" : "365" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Resource logs in Key Vault should be enabled")
    parameter_values = jsonencode({
        effect = { "value" : "AuditIfNotExists" }
        requiredRetentionDays = { "value" : "365" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Certificates should be issued by the specified integrated certificate authority")
    parameter_values = jsonencode({
        allowedCAs = { "value" : ["DigiCert", "GlobalSign"] }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Certificates should have the specified maximum validity period")
    parameter_values = jsonencode({
        maximumValidityInMonths = { "value" : 12 }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Certificates should use allowed key types")
    parameter_values = jsonencode({
        allowedKeyTypes = { "value" : ["RSA", "RSA-HSM"] }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Certificates using elliptic curve cryptography should have allowed curve names")
    parameter_values = jsonencode({
        allowedECNames = { "value" : ["P-256", "P-256K", "P-384", "P-521"] }
        effect = { "value" : "audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Keys should be the specified cryptographic type RSA or EC")
    parameter_values = jsonencode({
        allowedKeyTypes = { "value" : ["RSA", "RSA-HSM", "EC", "EC-HSM"] }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }

  policy_definition_reference {
    policy_definition_id = lookup(local.policy_definition_map, "Keys using elliptic curve cryptography should have the specified curve names")
    parameter_values = jsonencode({
        allowedECNames = { "value" : ["P-256", "P-256K", "P-384", "P-521"] }
        effect = { "value" : "Audit" }
    })
    reference_id = null
  }
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
```
</details>
