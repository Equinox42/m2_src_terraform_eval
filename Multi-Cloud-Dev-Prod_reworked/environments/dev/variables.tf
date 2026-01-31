variable "enable_aws" {
  description = "enable aws"
  type = bool
}

variable "enable_azure" {
    description = "enable azure"
    type = bool
}

variable "enable_gcp" {
    description = "enable google cloud platform"
    type = bool
}

variable "enable_libvirt" {
    description = "enable libvirt"
    type = bool
}

variable "environment" {
    description = "Environment to deploy, either dev or prod"
    nullable = false
    default = "dev"
    type = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be set to dev or prod"
  }
}

variable "team" {
  description = "Team name, this is used for budget tracking"
  type = string
  nullable = false 
}

#############################
### AWS RELATED VARIABLES ###
#############################

variable "aws_region" {
  description = "Which AWS Region you want to deploy ressources"
  type = string
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
variable "instances" {
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
  type = string

}

variable "ssh_key" {
  # This one could be passed with env variable through github secrets/variable with TF_VAR_ssh_key 
  description = "content of the ssh public key"
  type = string
  
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

