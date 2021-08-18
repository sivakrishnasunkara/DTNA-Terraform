terraform {
  backend "azurerm" {
    resource_group_name  = "TestRG"
    storage_account_name = "dtnaterraformsa"
    container_name       = "terraform-container"
    key                  = "terraform.tfstate"
  }
}
