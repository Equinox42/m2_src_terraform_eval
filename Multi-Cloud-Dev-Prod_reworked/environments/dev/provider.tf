terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.58.0"
    }
    google = {
      source = "hashicorp/google"
      version = "7.17.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {

  region = var.region

}


