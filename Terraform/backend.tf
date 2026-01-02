terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"
    storage_account_name = "tfstate1899995651" # Use the name from step 1
    container_name       = "tfstate"
    key                  = "resume.terraform.tfstate" # This is the name of the file
  }
}