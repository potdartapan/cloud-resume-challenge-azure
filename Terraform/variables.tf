variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
  default     = "test-rg-delete"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "westus2"
}

variable "storage_account_name" {
  description = "Storage account name for Terraform backend"
  type        = string
  sensitive   = true
  default     = "storageaccountesttf123"
}

