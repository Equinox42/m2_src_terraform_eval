terraform {
  ### Minimum terraform version required for planning and applying the resources
  required_version = ">=1.6.6"
  required_providers {
    ### Minimum Hashicorp/Azurerm Provider version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}