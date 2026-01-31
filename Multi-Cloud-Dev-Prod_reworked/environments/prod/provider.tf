terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.17.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {

  region = var.aws_region
  # To use the provider, user should provide authentification as environment variables
  #export AWS_ACCESS_KEY_ID="AKIA..."
  #export AWS_SECRET_ACCESS_KEY="wJalr..."
}


# Configure the Azure Provider
provider "azurerm" {
  # User will make use of az login to authenticate 
}


# Configure the GCP Provider
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}