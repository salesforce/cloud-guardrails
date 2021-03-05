# azure-guardrails

Command-line tool that generates Azure Policies based on requirements and transforms them into Terraform.

# TODO

Major:
* Add ability to export with Terraform
* Add ability to exclude based on YAML
* Add ability to generate Terraform based on YAML, not just on the command line options
* Add ability to look up the rule content based on a name

Tweaks:
* Add ability to use policies with parameters as long as they have default values

Enhancement:
* Add ability to supply the values that you want to put in the policy?

# References

* [Azure Policy Definition Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
* [Authorization Schemas](https://github.com/Azure/azure-resource-manager-schemas/search?q=schemas+in%3Apath+filename%3AMicrosoft.Authorization.json)
* [Pydantic Datamodel code generator](https://pydantic-docs.helpmanual.io/datamodel_code_generator/)
