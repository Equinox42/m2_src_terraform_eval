variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Azure region where to deploy ressources"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "vnet_cidr" {
  description = "VNet CIDR"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "internal"
}

variable "subnet_prefixes" {
  description = "Subnet prefixes"
  type        = list(string)
}