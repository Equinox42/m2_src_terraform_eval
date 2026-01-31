module "aws_compute" {

  source      = "../../modules/aws/compute"
  count       = var.enable_aws ? 1 : 0
  team        = var.team
  environment = var.environment
  instances   = var.aws_instances
  vm_user     = var.vm_user
  ami_id      = var.ami_id
  distro      = var.distro
  ssh_key     = var.aws_ssh_key

}

module "azure_network" {
  source              = "../../modules/azure/network"
  count               = var.enable_azure_network_module ? 1 : 0
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_name         = var.subnet_name
  vnet_name           = var.vnet_name
  vnet_cidr           = var.vnet_cidr
  subnet_prefixes     = var.subnet_prefixes
}

module "azure_compute" {
  source              = "../../modules/azure/compute"
  count               = var.enable_azure_compute_module ? 1 : 0
  team = var.team
  environment = var.environment
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  subnet_id           = module.network.subnet_id
  vm_user             = var.vm_user
  ssh_key             = var.azure_ssh_key
  instances = var.azure_instances  
  gallery_name = var.gallery_name
  gallery_resource_group_name = var.gallery_resource_group_name
}


module "gcp_compute" {

  source = "../../modules/gcp/compute"
  count  = var.enable_gcp ? 1 : 0
  #...
  #...
}