provider "azurerm"{
    version = "2.4.0"
    subscription_id = "d9cff28b-eba4-4cb6-b562-2d88c545f931"
    tenant_id = "aef6baf5-6231-4690-9308-23d674d56b05"
    client_id = "1d2b3d5c-0c3d-4d99-967e-307e7d714d13"

    features{}
}
resource "azurerm_resource_group" "RG1" {
  name     = var.resourceGroup
  location = var.rglocation
}
# resource "azurerm_virtual_network" "dtnanetwork" {
#   name                = var.network
#   resource_group_name = "${azurerm_resource_group.RG1.name}"
#   location            = "${azurerm_resource_group.RG1.location}"
#   address_space       = var.addrspace
#   subnet {
#     name           = var.subnetone
#     address_prefix = var.subnetoneaddr
#   }

#   subnet {
#     name           = var.subnettwo
#     address_prefix = var.subnettwoaddr
#   }

#   subnet {
#     name           = var.subnetthree
#     address_prefix = var.subeneththreeaddr
#   }
# }
resource "azurerm_databricks_workspace" "bricks" {
  name                = var.databricks
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  sku                 = var.databrickscompute

  tags = {
    Environment = "var.databrickstag"
  }
}
resource "azurerm_storage_account" "sgacc" {
  name                     = var.dtnadatalake
  resource_group_name      = azurerm_resource_group.RG1.name
  location                 = azurerm_resource_group.RG1.location
  account_tier             = var.datalakeaccounttier
  account_replication_type = var.datalakereplication
  account_kind             = var.datalakeaccountkind
  is_hns_enabled           = var.storagehns
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dtnahisdata" {
  name               = "dtnahisdatalake"
  storage_account_id = azurerm_storage_account.sgacc.id

  properties = {
    hello = "siva12345"
  }
}
# resource "azurerm_eventhub_namespace" "ehname" {
#   name                = "dtnanamespace"
#   location            = azurerm_resource_group.RG1.location
#   resource_group_name = azurerm_resource_group.RG1.name
#   sku                 = "Standard"
#   capacity            = 1

#   tags = {
#     environment = "Production"
#   }
# }
# resource "azurerm_eventhub" "ehhub" {
#   name                = "dtnaiothub"
#   namespace_name      = azurerm_eventhub_namespace.ehname.name
#   resource_group_name = azurerm_resource_group.RG1.name
#   partition_count     = 2
#   message_retention   = 1
# }
# resource "azurerm_eventhub_authorization_rule" "ehrule" {
#   name                = "dtnapolicy"
#   namespace_name      = azurerm_eventhub_namespace.ehname.name
#   eventhub_name       = azurerm_eventhub.ehhub.name
#   resource_group_name = azurerm_resource_group.RG1.name
#   listen              = true
#   send                = true
#   manage              = true
# }
# resource "azurerm_eventhub_consumer_group" "cg" {
#   name                = "cgtsaadx"
#   namespace_name      = azurerm_eventhub_namespace.ehname.name
#   eventhub_name       = azurerm_eventhub.ehhub.name
#   resource_group_name = azurerm_resource_group.RG1.name
#   user_metadata       = "some-meta-data"
# }
resource "azurerm_kusto_cluster" "cluster" {
  name                = var.dtnaadxcluster
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  sku {
    name     = var.adxclustercompute
    capacity = var.adxclustercapacity
  }
}
resource "azurerm_kusto_database" "database" {
  name                = var.dtnaadxdatabase
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  cluster_name        = azurerm_kusto_cluster.cluster.name
  hot_cache_period    = var.adxdatabasecacheperiod
  soft_delete_period  = var.adxdatabasedelperiod
}
# resource "azurerm_kusto_eventhub_data_connection" "eventhub_connection" {
#   name                = "my-kusto-eventhub-data-connection"
#   resource_group_name = azurerm_resource_group.RG1.name
#   location            = azurerm_resource_group.RG1.location
#   cluster_name        = azurerm_kusto_cluster.cluster.name
#   database_name       = azurerm_kusto_database.database.name

#   eventhub_id    = azurerm_eventhub.ehhub.id
#   consumer_group = azurerm_eventhub_consumer_group.cg.name

#   table_name        = "my-table"         #(Optional)
#   mapping_rule_name = "my-table-mapping" #(Optional)
#   data_format       = "JSON"             #(Optional)
# }

# resource "azurerm_data_factory" "factory" {
#   name                = "dtnafactory"
#   location            = azurerm_resource_group.RG1.location
#   resource_group_name = azurerm_resource_group.RG1.name
# }

# creating data factory
resource "azurerm_data_factory" "dtnadatafactory" {
  name                = var.dtnadatafactory
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
}