module "aws_compute" {

    source = "../../modules/aws/compute"
    count  = var.enable_aws ? 1 : 0

}


