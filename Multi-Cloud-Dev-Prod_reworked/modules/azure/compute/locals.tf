locals {
  
  latest_stable_images = {
    for distro, data in data.azurerm_shared_image_versions.images : 
    distro => data.images[length(data.images) - 1].id
    if length(data.images) > 0
  }

  # cloud init
  cloud_init_content = templatefile("${path.module}/templates/cloud_init.yaml.tftpl", {

    username      = var.vm_user
    ssh_key_value = var.ssh_key
  })


  gallery_image_definitions = {
    debian = "Debian-13" 
    rocky  = "Rocky-11"   
  }

  common_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
    Module      = "azure-compute"
    Team        = var.team
  }
}

