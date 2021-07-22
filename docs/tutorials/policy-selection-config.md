# Selecting Policies using the Config File

Let's say that you want more granular control over which policies to apply. You can create a config file to manage this.

To create the config file, run the following command:

```bash
# Create Config file
cloud-guardrails create-config-file --output config.yml
```

This generates a file called `config.yml` with the following contents:

<details>
<summary>Click to expand!</summary>
<p>

```yaml
####
# match_only_keywords: Use this to only apply policies that match any of these keywords
# exclude_keywords: Use this to skip policies that have any of these keywords in the display name
# exclude_services: Specify services that you want to exclude entirely.
# exclude_policies: Specify Azure Policy Definition displayNames that you want to exclude from the results, sorted by service
####

# Use this to only apply policies that match any of these keywords
# Example: "encrypt", "SQL", "HTTP"
match_only_keywords:
  - ""


exclude_keywords:
  - ""
  - "virtual network service endpoint"
  #- "private link"


# Specify services that you want to exclude entirely.
# Uncomment the services mentioned below if you want to exclude them.
exclude_services:
  - ""
  - "Guest Configuration"

  #- "API Management"
  #- "API for FHIR"
  #- "App Configuration"
  #- "App Platform"
  #- "App Service"
  #- "Attestation"
  #- "Automanage"
  #- "Automation"
  #- "Azure Active Directory"
  #- "Azure Data Explorer"
  #- "Azure Stack Edge"
  #- "Backup"
  #- "Batch"
  #- "Bot Service"
  #- "Cache"
  #- "Cognitive Services"
  #- "Compute"
  #- "Container Instance"
  #- "Container Registry"
  #- "Cosmos DB"
  #- "Custom Provider"
  #- "Data Box"
  #- "Data Factory"
  #- "Data Lake"
  #- "Event Grid"
  #- "Event Hub"
  #- "General"
  #- "HDInsight"
  #- "Internet of Things"
  #- "Key Vault"
  #- "Kubernetes"
  #- "Kubernetes service"
  #- "Lighthouse"
  #- "Logic Apps"
  #- "Machine Learning"
  #- "Managed Application"
  #- "Media Services"
  #- "Migrate"
  #- "Monitoring"
  #- "Network"
  #- "Portal"
  #- "SQL"
  #- "Search"
  #- "Security Center"
  #- "Service Bus"
  #- "Service Fabric"
  #- "SignalR"
  #- "Site Recovery"
  #- "Storage"
  #- "Stream Analytics"
  #- "Synapse"
  #- "Tags"
  #- "VM Image Builder"
  #- "Web PubSub"


# Specify Azure Policy Definition displayNames that you want to exclude from the results
exclude_policies:
  General:
    - "Allow resource creation only in Asia data centers"
    - "Allow resource creation only in European data centers"
    - "Allow resource creation only in India data centers"
    - "Allow resource creation only in United States data centers"
  Tags:
    - "Allow resource creation if 'department' tag set"
    - "Allow resource creation if 'environment' tag value in allowed values"
  API Management:
    # This collides with the same one from App Platform
    - "API Management services should use a virtual network"
  App Platform:
    # This collides with the same one from API Management
    - "Azure Spring Cloud should use network injection"
  Guest Configuration:
    # This outputs a parameter called "Cert:" that breaks the parameter yaml format
    - "Audit Windows machines that contain certificates expiring within the specified number of days"
  Network:
    # This one is overly cumbersome for most organizations
    - "Network interfaces should not have public IPs"



  API for FHIR:
    - ""

  App Configuration:
    - ""

  App Service:
    - ""

  Attestation:
    - ""

  Automanage:
    - ""

  Automation:
    - ""

  Azure Active Directory:
    - ""

  Azure Data Explorer:
    - ""

  Azure Stack Edge:
    - ""

  Backup:
    - ""

  Batch:
    - ""

  Bot Service:
    - ""

  Cache:
    - ""

  Cognitive Services:
    - ""

  Compute:
    - ""

  Container Instance:
    - ""

  Container Registry:
    - ""

  Cosmos DB:
    - ""

  Custom Provider:
    - ""

  Data Box:
    - ""

  Data Factory:
    - ""

  Data Lake:
    - ""

  Event Grid:
    - ""

  Event Hub:
    - ""

  HDInsight:
    - ""

  Internet of Things:
    - ""

  Key Vault:
    - ""

  Kubernetes:
    - ""

  Kubernetes service:
    - ""

  Lighthouse:
    - ""

  Logic Apps:
    - ""

  Machine Learning:
    - ""

  Managed Application:
    - ""

  Media Services:
    - ""

  Migrate:
    - ""

  Monitoring:
    - ""

  Portal:
    - ""

  SQL:
    - ""

  Search:
    - ""

  Security Center:
    - ""

  Service Bus:
    - ""

  Service Fabric:
    - ""

  SignalR:
    - ""

  Site Recovery:
    - ""

  Storage:
    - ""

  Stream Analytics:
    - ""

  Synapse:
    - ""

  VM Image Builder:
    - ""

  Web PubSub:
    - ""

```
</details>

It has a few different sections, which we cover below.

## Matching Keywords

If you want to select policies based on the keywords of the policy name, you can insert those keywords in the `match_only_keywords` list in the `config.yml` file. For example, let's say you only want to apply the SQL-related policies:

```yaml
match_only_keywords:
  - "SQL"
```

!!! note
    **Don't know the names of the policies?** If you want to show the names of all the policies, you can use the  `list-policies` command to list all of them. You can also filter the results based on which service or whether parameters are required/optional/not required:
    ```bash
    cloud-guardrails list-policies --service "Kubernetes" --all-policies
    cloud-guardrails list-policies --service "Kubernetes" --no-params
    cloud-guardrails list-policies --service "Kubernetes" --audit-only
    ```


## Excluding Policies based on Keywords

Let's say that you don't want to apply any of the policies that mention Private Link or Virtual Network Service Endpoints. You can insert those keywords in the `exclude_keywords` list to skip policies that have any of these keywords in the display name:

```yaml
exclude_keywords:
  - "virtual network service endpoint"
  - "private link"
```

!!! note
    **Don't know the names of the policies?** If you want to show the names of all the policies, you can use the  `list-policies` command to list all of them. You can also filter the results based on which service or whether parameters are required/optional/not required:
    ```bash
    cloud-guardrails list-policies --service "Kubernetes" --all-policies
    cloud-guardrails list-policies --service "Kubernetes" --no-params
    cloud-guardrails list-policies --service "Kubernetes" --audit-only
    ```

## Excluding Services

If you don't want to apply any policies within a particular service - let's say, the "Guest Configuration" service, or Azure Kubernetes service - you can specify the names of the services using the `exclude_services` list, like below:

```yaml
exclude_services:
  - "Guest Configuration"
  - "Kubernetes"
  - "Kubernetes service"
```

!!! note
    **Don't know the names of the services?**
    If you don't know the names of the services to include, you can use the `list-services` command to list all the services supported by Azure built-in Policies:
    ```bash
    cloud-guardrails list-services
    ```

## Excluding specific policies

If you want to exclude specific policies entirely, you can specify the display names for those policies that you want to exclude using the `exclude_policies` list, like below:

```yaml
exclude_policies:
  General:
    - "Allow resource creation only in Asia data centers"
    - "Allow resource creation only in European data centers"
    - "Allow resource creation only in India data centers"
    - "Allow resource creation only in United States data centers"
```

!!! note
    **Don't know the names of the policies?** If you don't know the names of the services to include, you can use the `list-policies` command to list all the services supported by Azure built-in Policies.
    ```bash
    cloud-guardrails list-policies --service "Kubernetes" --all-policies
    cloud-guardrails list-policies --service "Kubernetes" --no-params
    cloud-guardrails list-policies --service "Kubernetes" --audit-only
    ```
