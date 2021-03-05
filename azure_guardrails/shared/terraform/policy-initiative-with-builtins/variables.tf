# ---------------------------------------------------------------------------------------------------------------------
# Details about which policies to apply and at what level (enforcement=true or enforcement=false)
# ---------------------------------------------------------------------------------------------------------------------
variable "policy_names" {
  type        = list(string)
  description = "The names of the Azure Policy names to apply."
}

variable "enforcement_mode" {
  description = "Can be set to `true` or `false` to control whether the assignment is enforced (`true`) or not (`false`). DEFAULTS TO FALSE."
  default     = false
  type        = bool
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Target details
# ---------------------------------------------------------------------------------------------------------------------
variable "subscription_name" {
  description = "The name of the subscription. If set, it will apply the policy to this subscription only."
  default     = ""
  type        = string
}

variable "management_group" {
  description = "The name or UUID of this management group. If set, it will apply the policy to the management group level."
  default     = ""
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative Metadata
# ---------------------------------------------------------------------------------------------------------------------

variable "policy_set_definition_category" {
  type        = string
  description = "The category of this policy definition group."
}

variable "policy_set_name" {
  type        = string
  description = "The name of the policy set definition. Changing this forces a new resource to be created."
}

variable "display_name" {
  type        = string
  description = "The display name of the policy set definition."
}

variable "description" {
  description = "The description of the policy set definition."
  type        = string
}
