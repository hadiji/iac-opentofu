terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.50.0"
    }
  }

/*
  backend "azurerm" {
    storage_account_name = module.storage_state_file.terraform_state_storage_account
    container_name       = module.storage_state_file.terraform_state_storage_container_core
    key                  = "${terraform.workspace}.tfstate"
    access_key           = module.storage_state_file.terraform_state_storage_access_key
  }*/
}

provider "azurerm" {
  features {}
}

