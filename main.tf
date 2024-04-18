terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  required_version = ">=1.1.0"

  cloud {
    organization = "Bean"
    workspaces {
      name = "WP1"
    }
  }
}

provider "azurerm" {
  features {}
}
