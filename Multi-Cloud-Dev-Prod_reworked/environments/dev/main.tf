module "aws_compute" {

  source      = "../../modules/aws/compute"
  count       = var.enable_aws ? 1 : 0
  team        = var.team
  environment = var.environment
  instances   = var.instances
  vm_user     = var.vm_user
  ami_id      = var.ami_id
  distro      = var.distro
  ssh_key     = var.ssh_key

}


module "azure_network" {
  source          = "../../modules/azure/network"
  count           = var.enable_azure ? 1 : 0
  subnet_name     = var.subnet_name
  subnet_prefixes = var.subnet_prefixes
  vnet_name       = var.vnet_name
  location        = var.location
  vnet_cidr       = var.vnet_cidr


}

module "azure_compute" {

  source = "../../modules/azure/compute"
  count  = var.enable_azure ? 1 : 0



}

module "gcp_compute" {

  source = "../../modules/gcp/compute"
  count  = var.enable_gcp ? 1 : 0 
  
}