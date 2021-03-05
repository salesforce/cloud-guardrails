# Azure Policy Initiative with Built-in Policies

## Tutorial

* Install Terraform locally

```bash
brew install tfenv
tfenv install 0.12.28
tfenv use 0.12.28
```

* Authenticate to Azure

```bash
az login
```

* Change to the `simple` example.

```bash
cd examples/simple
```

* Set the active subscription to make sure you are in the correct tenant. We will be using the `example` subscription.


```bash
az account set --subscription "redscar-dev"
```


* Create the Terraform resources

```bash
terraform init
terraform plan
terraform apply -auto-apply
```

* To add more policies, get the name of the Built-in Azure Policy and add it to your `main.tf`, like this:

```hcl
locals { name = "example" }

module "acr_policies" {
  source                         = "git@github.com:kmcquade/azure-guardrails.git//azure_guardrails/shared/terraform/policy-initiative-with-builtins"
  description                    = local.name
  display_name                   = local.name
  subscription_name              = "example"
  enforcement_mode               = false
  policy_set_definition_category = local.name
  policy_set_name                = local.name
  policy_names = [
    "Container registries should be encrypted with a customer-managed key",
    "Container registries should use private link",
    "Container registries should not allow unrestricted network access",
    # TODO: You can add more policies here. It must equal the exact name of the policy. You can find the policy definitions in Azure Portal under the Policies blade.
  ]
}

```

[^]: (autogen_docs_start)
<!-- @IGNORE PREVIOUS: link -->

[^]: (autogen_docs_end)
<!-- @IGNORE PREVIOUS: link -->