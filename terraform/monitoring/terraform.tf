terraform {
  required_version = "~> 0.13.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.29.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.12.6"
    }
  }
  backend "azurerm" {
  }
}

provider cloudfoundry {
  api_url      = local.paas_api_url
  user         = var.paas_user != "" ? var.paas_user : null
  password     = var.paas_password != "" ? var.paas_password : null
  sso_passcode = var.paas_sso_code != "" ? var.paas_sso_code : null
}
