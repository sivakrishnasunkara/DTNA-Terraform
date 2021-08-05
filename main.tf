provider "azurerm" {
    version = "2.4.0"
    subscription_id= "d9cff28b-eba4-4cb6-b562-2d88c545f931"
    tenant_id= "aef6baf5-6231-4690-9308-23d674d56b05"
    client_id="1d2b3d5c-0c3d-4d99-967e-307e7d714d13"

    features{}

}
resource "azurerm_resource_group" "RG1" {
  name     = "DTNA-TSA-RG"
  location = "West Europe"
}
resource "azurerm_virtual_network" "dtnanetwork" {
  name                = "dev-network"
  resource_group_name = "${azurerm_resource_group.RG1.name}"
  location            = "${azurerm_resource_group.RG1.location}"
  address_space       = ["10.0.0.0/16"]
  
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }
}
resource "azurerm_databricks_workspace" "bricks" {
  name                = "databricks-testone"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  sku                 = "standard"

  tags = {
    Environment = "dev"
  }
}
resource "azurerm_storage_account" "sgacc" {
  name                     = "dtnatsalake"
  resource_group_name      = azurerm_resource_group.RG1.name
  location                 = azurerm_resource_group.RG1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}
resource "azurerm_eventhub_namespace" "ehname" {
  name                = "dtnanamespace"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Production"
  }
}
resource "azurerm_eventhub" "ehhub" {
  name                = "dtnaiothub"
  namespace_name      = azurerm_eventhub_namespace.ehname.name
  resource_group_name = azurerm_resource_group.RG1.name
  partition_count     = 2
  message_retention   = 1
}
resource "azurerm_eventhub_authorization_rule" "ehrule" {
  name                = "dtnapolicy"
  namespace_name      = azurerm_eventhub_namespace.ehname.name
  eventhub_name       = azurerm_eventhub.ehhub.name
  resource_group_name = azurerm_resource_group.RG1.name
  listen              = true
  send                = true
  manage              = true
}
resource "azurerm_eventhub_consumer_group" "cg" {
  name                = "cgtsaadx"
  namespace_name      = azurerm_eventhub_namespace.ehname.name
  eventhub_name       = azurerm_eventhub.ehhub.name
  resource_group_name = azurerm_resource_group.RG1.name
  user_metadata       = "some-meta-data"
}
resource "azurerm_kusto_cluster" "cluster" {
  name                = "tsacluster"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  sku {
    name     = "Standard_D13_v2"
    capacity = 2
  }
}
resource "azurerm_kusto_database" "database" {
  name                = "dtnadatabase"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  hot_cache_period    = "P7D"
  soft_delete_period  = "P31D"
}
resource "azurerm_kusto_eventhub_data_connection" "eventhub_connection" {
  name                = "my-kusto-eventhub-data-connection"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  database_name       = azurerm_kusto_database.database.name

  eventhub_id    = azurerm_eventhub.ehhub.id
  consumer_group = azurerm_eventhub_consumer_group.cg.name

  table_name        = "my-table"         #(Optional)
  mapping_rule_name = "my-table-mapping" #(Optional)
  data_format       = "JSON"             #(Optional)
}
