variable "environment" {
    description = "Environment to deploy, either dev or prod"
    nullable = false
    type = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be set to dev or prod"
  }

}

variable "ami_id" {
  description = "AMI ID of the instance - must be tagged with stable"
  type        = string
}

variable "distro" {
  description = "OS Distribution expected"
  type        = string
  validation {
    condition     = contains(["debian", "rocky"], var.os_family)
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

