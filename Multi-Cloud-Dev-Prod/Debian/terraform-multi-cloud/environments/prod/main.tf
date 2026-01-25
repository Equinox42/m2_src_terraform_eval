terraform {
  required_providers {
    aws     = { source = "hashicorp/aws" }
    google  = { source = "hashicorp/google" }
    azurerm = { source = "hashicorp/azurerm" }
    libvirt = { source = "dmacvicar/libvirt" }
  }
}

provider "aws"     { region = "eu-west-3" }
provider "google"  { project = "VOTRE_PROJET_ID" }
provider "azurerm" { features {} }
provider "libvirt" { uri = "qemu:///system" }

module "prod_stack" {
  source      = "../../modules/vm_stack"
  environment = "prod"
  vm_count    = 3
}
