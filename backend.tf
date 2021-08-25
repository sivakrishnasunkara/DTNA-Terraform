terraform {
  backend "azurerm" {
    resource_group_name  = "tfrg"
    storage_account_name = "tfstatefiledtna"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}