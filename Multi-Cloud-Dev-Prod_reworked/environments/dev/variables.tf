variable "enable_aws" {
  description = "enable aws"
  type        = bool
}

variable "enable_azure_network_module" {
  description = "enable azure"
  type        = bool
}

variable "enable_azure_compute_module" {
  description = "enable azure compute module"
  type        = bool
}

variable "enable_gcp" {
  description = "enable google cloud platform"
  type        = bool
}

variable "enable_libvirt" {
  description = "enable libvirt"
  type        = bool
}

variable "environment" {
  description = "Environment to deploy, either dev or prod"
  nullable    = false
  default     = "dev"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be set to dev or prod"
  }
}

variable "team" {
  description = "Team name, this is used for budget tracking"
  type        = string
  nullable    = false
}

#############################
### AWS RELATED VARIABLES ###
#############################

variable "aws_region" {
  description = "Which AWS Region you want to deploy ressources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID of the instance - must be tagged with stable"
  type        = string
}

variable "distro" {
  description = "OS Distribution expected"
  type        = string
  validation {
    condition     = contains(["debian", "rocky"], var.distro)
    error_message = "must be either debian or rocky"
  }
}
variable "aws_instance" {
  description = "Instances Configuration"
  type = map(object({
    instance_type    = string
    root_disk_size   = number
    extra_disk_count = number
    extra_disk_size  = number
  }))

}

variable "vm_user" {
  description = "User of the VM"
  type        = string
}

variable "aws_ssh_key" {
  # This one could be passed with env variable through github secrets/variable with TF_VAR_ssh_key although it's only a .pub key 
  description = "content of the ssh public key"
  type        = string
}


###############################
### AZURE RELATED VARIABLES ###
###############################

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


variable "azure_ssh_key" {
  description = "content of the public key"
  type = string
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

#############################
### GCP RELATED VARIABLES ###
#############################

variable "gcp_project" {
  description = "ID of the gcp project"
  type        = string
  nullable    = false
}

variable "gcp_region" {
  description = "Which gcp region you want to deploy your resources"
  type        = string
}

variable "gcp_zone" {
  description = "Which gcp zone you want to depoy your resources"
  type        = string
}

