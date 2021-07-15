# Guardrails for Azure

Guardrails for Azure is a command-line tool that allows you to rapidly cherry-pick security guardrails in the form of Azure Policy Initiatives.

# Overview

[Azure Policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview) - similar to [AWS Service Control Policies (SCPs)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html) - allows Azure customers to enforce organizational standards and enforce security policies at scale. You can use Azure Policies to evaluate the overall state of your environment, and drill down to the security status per resource and per policy. **For example, you can prevent users from creating any unencrypted resources or security group rules that allow SSH/RDP Access to 0.0.0.0/0**.

Azure Provides **400+ built-in security policies**. This presents an incredible opportunity for customers who want to enforce preventative security guardrails from the start. However, deciding which of the 400+ built-in policies you want to enforce, and which stages you want to roll them out in can be a bit intimidating at the start.

To help maximize coverage and ease the rollout process, I created this tool so that you can:

* **Cherry-pick and bulk-select the security policies you want** according to your specific criteria
* Enforce low-friction policies within **minutes**
* Easily roll back policies that you don't want
