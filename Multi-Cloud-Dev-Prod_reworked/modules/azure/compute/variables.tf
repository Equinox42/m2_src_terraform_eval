variable "resource_group_name" {
  description = "Azure resource groupe name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "subnet_id" {
  description = "ID of subnet where NICs should be placed"
  type        = string
}

variable "vm_user" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "instances" {
  description = "Configuration of the VMs"
  type = map(object({
    instance_type    = string
    root_disk_size   = number
    extra_disk_count = number
    extra_disk_size  = number
  }))
}