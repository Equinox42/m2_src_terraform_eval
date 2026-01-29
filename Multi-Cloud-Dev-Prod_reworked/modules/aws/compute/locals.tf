locals {
  # cloud init
  cloud_init_content = templatefile("${path.module}/templates/cloud_init.yaml.tftpl", {

    username      = var.vm_user
    ssh_key_value = var.ssh_key
  })

  common_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
    Module      = "aws-compute"
    Team        = var.team
    Owner       = var.vm_user

  }
}