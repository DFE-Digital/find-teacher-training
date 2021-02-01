terraform {
  required_version = "~> 0.13.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.45.1"
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
  backend azurerm {
  }
}

provider azurerm {
  features {}

  skip_provider_registration = true
  subscription_id            = local.azure_credentials.subscriptionId
  client_id                  = local.azure_credentials.clientId
  client_secret              = local.azure_credentials.clientSecret
  tenant_id                  = local.azure_credentials.tenantId
}

module paas {
  source = "./modules/paas"

  cf_api_url                = local.cf_api_url
  cf_user                   = local.infra_secrets.CF_USER
  cf_user_password          = local.infra_secrets.CF_PASSWORD
  cf_sso_passcode           = var.paas_sso_code
  cf_space                  = var.paas_cf_space
  app_environment           = var.paas_app_environment
  app_docker_image          = var.paas_app_docker_image
  web_app_instances         = var.paas_web_app_instances
  web_app_memory            = var.paas_web_app_memory
  logstash_url              = local.infra_secrets.LOGSTASH_URL
  app_environment_variables = local.paas_app_environment_variables
  docker_credentials        = local.docker_credentials
}

provider statuscake {
  username = local.infra_secrets.STATUSCAKE_USERNAME
  apikey   = local.infra_secrets.STATUSCAKE_PASSWORD
}

module statuscake {
  source = "./modules/statuscake"

  alerts = var.statuscake_alerts
}
