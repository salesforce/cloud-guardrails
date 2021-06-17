# Cheatsheet

### Writing Policies
```bash
# No Parameters
azure-guardrails generate-terraform --no-params --subscription example

# Optional Parameters (i.e., all the policies have default parameter values)
azure-guardrails generate-terraform --params-optional --subscription example

# Required Parameters
azure-guardrails generate-terraform --params-required \
    --service Kubernetes \
    --subscription example

# Create Config file
azure-guardrails create-config-file --output config.yml

# Create Parameters file
azure-guardrails create-parameters-file --output parameters.yml
```

### Querying Policy Data

```
# list-services: List all the services supported by Azure built-in Policies
azure-guardrails list-services

# list-policies: List all the existing built-in Azure Policies
azure-guardrails list-policies --service "Kubernetes" --all-policies
azure-guardrails list-policies --service "Kubernetes" --no-params
azure-guardrails list-policies --service "Kubernetes" --audit-only

# describe-policy: Describe a specific policy based on display name or the short policy ID
azure-guardrails describe-policy --id 7c1b1214-f927-48bf-8882-84f0af6588b1
azure-guardrails describe-policy --name "Storage accounts should use customer-managed key for encryption"
```
