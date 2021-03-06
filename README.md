# azure-guardrails

Command-line tool that generates Azure Policies based on requirements and transforms them into Terraform.

# Instructions

```bash
azure-guardrails generate-terraform -d ./
```

* Output:

```hcl
locals { name = "test" }

module "name" {
  source                         = "git@github.com:kmcquade/azure-guardrails.git//azure_guardrails/shared/terraform/policy-initiative-with-builtins"
  description                    = local.name
  display_name                   = local.name
  subscription_name              = "example-subscription"
  management_group               = ""
  enforcement_mode               = false
  policy_set_definition_category = local.name
  policy_set_name                = local.name
  policy_names = [
    "Azure Key Vault Managed HSM should have purge protection enabled",
    "Firewall should be enabled on Key Vault",
    "Key Vault keys should have an expiration date",
    "Key Vault secrets should have an expiration date",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "Keys should be backed by a hardware security module (HSM)",
    "Private endpoint should be configured for Key Vault",
    "Secrets should have content type set",
  ]
}
```

# TODO

Major:
* Add ability to export with Terraform
* Add ability to exclude based on YAML
* Add ability to generate Terraform based on YAML, not just on the command line options
* Add ability to look up the rule content based on a name

Tweaks:
* Add ability to use policies with parameters as long as they have default values
* Add comments in the Terraform output?

Enhancement:
* Add ability to supply the values that you want to put in the policy?

# References

* [Azure Policy Definition Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
* [Authorization Schemas](https://github.com/Azure/azure-resource-manager-schemas/search?q=schemas+in%3Apath+filename%3AMicrosoft.Authorization.json)
* [Pydantic Datamodel code generator](https://pydantic-docs.helpmanual.io/datamodel_code_generator/)
