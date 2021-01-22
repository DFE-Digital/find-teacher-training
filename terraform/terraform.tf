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
    statuscake = {
      source  = "terraform-providers/statuscake"
      version = "1.0.0"
    }
  }
  backend "azurerm" {
  }
}

module paas {
  source = "./modules/paas"

  cf_api_url                = local.cf_api_url
  cf_user                   = var.paas_user
  cf_user_password          = var.paas_password
  cf_sso_passcode           = var.paas_sso_code
  app_environment           = var.paas_app_environment
  app_docker_image          = var.paas_app_docker_image
  web_app_instances         = var.paas_web_app_instances
  web_app_memory            = var.paas_web_app_memory
  logstash_url              = var.paas_logstash_url
  app_environment_variables = local.paas_app_environment_variables
  docker_credentials        = local.docker_credentials
}

provider statuscake {
  username = var.statuscake_username
  apikey   = var.statuscake_password
}

module statuscake {
  source = "./modules/statuscake"

  alerts = var.statuscake_alerts
}
