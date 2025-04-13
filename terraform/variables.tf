variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "databricks-secure-rg"
}

variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "hub_vnet_name" {
  description = "Hub VNet name"
  default     = "vnet-hub"
}

variable "spoke_vnet_name" {
  description = "Spoke VNet name for Databricks"
  default     = "vnet-spoke-databricks"
}

variable "hub_vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "hub_subnet_address_space" {
  default = ["10.0.0.0/24"] 
}

variable "spoke_vnet_address_space" {
  default = ["10.1.0.0/16"]
}

variable "spoke_subnet_address_space" {
  default = ["10.1.0.0/24"]
}

# variable subnet_databricks_public_name {
#   default = "databricks-vnet"
# }


# variable subnet_databricks_private_name {
#   default = "databricks-private-subnet"
# }


# variable "subnet_public_prefix_address" {
#   default = ["10.0.1.0/24"]
# }

# variable "subnet_private_prefix_address" {
#   default = ["10.0.2.0/24"]
# }


variable "environment" {
  default = "Production"
}

variable "owner" {
  default = "DataTeam"
}

# variable nsg_databricks_public_name {
#   default = "nsg-databricks-public"
# }

# variable nsg_databricks_private_name {
#   default = "nsg-databricks-private"
# }

# variable databricks_workspace_name {
#   default = "example-databricks"
# }

# variable databricks_workspace_sku {
#   default = "premium"
# }

# variable databricks_workspace_managed_resource_group_name {
#   default = "databricks-managed-rg"
# }