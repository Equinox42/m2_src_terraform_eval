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

variable "team" {
  description = "Team name, this is used for budget tracking"
  type        = string
  nullable    = false
}

variable "vm_user" {
  type = string
}

variable "ssh_key" {
  description = "content of the public key"
  type = string
}

variable "environment" {
  description = "Environment to deploy, either dev or prod"
  nullable    = false
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be set to dev or prod"
  }
}

variable "instances" {
  description = "Configuration of the VMs"
  type = map(object({
    instance_type    = string
    root_disk_size   = number
    extra_disk_count = number
    extra_disk_size  = number
    distro           = string
  }))

  validation {
    condition = alltrue([
      for k, v in var.instances : contains(["debian", "rocky"], v.distro)
    ])
    error_message = "OS distribution must be either 'debian' or 'rocky'."
  }
}

variable "gallery_name" {
  description = "Name of the Azure Compute Gallery (Shared Image Gallery)"
  type        = string
}

variable "gallery_resource_group_name" {
  description = "Resource Group where the Gallery is located"
  type        = string
}

variable "image_tag_filter" {
  description = "Tag filter to select the stable image version (e.g. { status = 'stable' })"
  type        = map(string)
  default     = {
    status = "stable"
  }
}