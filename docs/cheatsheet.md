# Cheatsheet

### Quick start

```bash
# Install Terraform (prerequisite)
brew install tfenv
tfenv install 0.12.31

# Install via Homebrew
brew tap salesforce/cloud-guardrails https://github.com/salesforce/cloud-guardrails
brew install cloud-guardrails

# Generate files for Guardrails that do not require parameters
cloud-guardrails generate-terraform --no-params --subscription example

# Log into Azure and set your subscription
az login
az account set --subscription example

# Apply the policies
terraform init
terraform plan
terraform apply -auto-approve
```

### Writing Policies

```bash
# No Parameters
cloud-guardrails generate-terraform --no-params --subscription example

# Optional Parameters (i.e., all the policies have default parameter values)
cloud-guardrails generate-terraform --params-optional --subscription example

# Required Parameters
cloud-guardrails generate-terraform --params-required \
    --service Kubernetes \
    --subscription example

# Create Config file
cloud-guardrails create-config-file --output config.yml

# Create Parameters file
cloud-guardrails create-parameters-file --output parameters.yml
```

### Querying Policy Data

```
# list-services: List all the services supported by Azure built-in Policies
cloud-guardrails list-services

# list-policies: List all the existing built-in Azure Policies
cloud-guardrails list-policies --service "Kubernetes" --all-policies
cloud-guardrails list-policies --service "Kubernetes" --no-params
cloud-guardrails list-policies --service "Kubernetes" --audit-only

# describe-policy: Describe a specific policy based on display name or the short policy ID
cloud-guardrails describe-policy --id 7c1b1214-f927-48bf-8882-84f0af6588b1
cloud-guardrails describe-policy --name "Storage accounts should use customer-managed key for encryption"
```
