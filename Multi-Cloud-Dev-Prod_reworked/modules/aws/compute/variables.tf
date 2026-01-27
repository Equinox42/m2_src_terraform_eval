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

variable "instances" {
  description = "Instances Configuration"
  type = map(object({
    instance_type    = string
    root_disk_size   = number
    extra_disk_count = number
    extra_disk_size  = number
  }))

}