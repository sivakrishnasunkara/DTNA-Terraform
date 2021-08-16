variable resourceGroup {
  type        = string
  default     = "DTNA-TSA-RG"
  description = "A resource group for the dtna resources"
}
variable rglocation {
    type = string
    default = "West Europe"
    description = "resource group location allocation"
}
variable network {
    type  = string
    default = "dev-network"
    description = "virtual network and subnets for the dtna resources"
}
variable addrspace {
    type = string
    default = "10.0.0.0/16"
    description = "address space for the networking"
}
variable subnetone {
    type = string
    default = "subnet1"
    description = "creating the subnet under Vnet"
}
variable subnetoneaddr {
    type = string
    default = "10.0.1.0/24"
    description = "CIDR notation for the subnet one"
}
variable subnettwo {
    type = string
    default = "subnet2"
    description = "craating the subnet udner Vnet"
}
variable subnettwoaddr {
    type = string
    default = "10.0.2.0/24"
    description = "craating CIDR notation for the subnet two "
}
variable subnetthree {
    type = string
    default = "subnet3"
    description = "creating subnet three under vnet"
}
variable subeneththreeaddr {
    type = string
    default ="10.0.3.0/24"
    description = "CIDR notation for the Subnet tree"
}
variable databricks {
    type  = string
    default = "databricks-testone"
    description = "databricks for processing the data and  building AI/Ml best practices"
}
variable databrickscompute {
    type = string
    default = "standard"
    description = "sku selection for the databricks"
}
variable databrickstag {
    type =string
    default = "dev"
}
variable dtnadatalake {
    type  = string
    default = "dtnatsalake"
    description = "datalake for maintaining the historical data"
}
variable datalakeaccounttier {
    type = string
    default = "Standard"
    description = "which tier of the datalake"
}
variable datalakereplication {
    type = string
    default = "LRS"
    description = "datalake replication for the disaster recovery"
}
variable datalakeaccountkind {
    type = string
    default = "StorageV2"
    description = "type of the storage account"
}
variable storagehns {
    type = string
    default = "true"
    description = "enabling the hns for the datalakegen2"
}
variable dtnaadxcluster {
    type  = string
    default = "tsacluster"
    description = "adx cluster for the streaming data ingestion into the database"
}
variable adxclustercompute {
    type = string
    default = "Standard_D13_v2"
    description = "choosing the right adx cluster for the streaming ingestion"
}
variable adxclustercapacity {
    type = string
    default = "2"
    description = "choosing the capacity for the cluster"
}
variable dtnaadxdatabase {
    type = string
    default = "dtnadatabase"
    description = "adx database for creating the tables for the landing data and analytics data"
}
variable adxdatabasecacheperiod {
    type = string
    default = "P7D"
    description = "choosing the cache period for the database"
}
variable adxdatabasedelperiod {
    type = string
    default = "P31D"
    description = "choose the delete period"
}

# creating data factory -variables
variable dtnadatafactory {
    type = string
    default = "dtnatsadatafactory"
    description = "tsa data factory for creating the data pipelines and preparation"
}