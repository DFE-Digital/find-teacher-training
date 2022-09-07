terraform {
  required_version = "~> 1.2.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.21.1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.15.5"
    }
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "2.0.4"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
  subscription_id            = try(local.azure_credentials.subscriptionId, null)
  client_id                  = try(local.azure_credentials.clientId, null)
  client_secret              = try(local.azure_credentials.clientSecret, null)
  tenant_id                  = try(local.azure_credentials.tenantId, null)
}

module "paas" {
  source = "./modules/paas"

  cf_api_url                = local.cf_api_url
  cf_user                   = var.paas_sso_code == "" ? local.infra_secrets.CF_USER : null
  cf_user_password          = var.paas_sso_code == "" ? local.infra_secrets.CF_PASSWORD : null
  cf_sso_passcode           = var.paas_sso_code
  cf_space                  = var.paas_cf_space
  app_environment           = var.paas_app_environment
  app_docker_image          = var.paas_app_docker_image
  app_environment_config    = var.paas_app_environment_config
  web_app_host_name         = var.paas_web_app_host_name
  web_app_instances         = var.paas_web_app_instances
  web_app_memory            = var.paas_web_app_memory
  worker_app_instances      = var.paas_worker_app_instances
  worker_app_memory         = var.paas_worker_app_memory
  redis_service_plan        = var.paas_redis_service_plan
  logstash_url              = local.infra_secrets.LOGSTASH_URL
  app_environment_variables = local.paas_app_environment_variables
  enable_external_logging   = var.paas_enable_external_logging
}

provider "statuscake" {
  api_token   = local.infra_secrets.STATUSCAKE_PASSWORD
}

module "statuscake" {
  source = "./modules/statuscake"

  alerts = var.statuscake_alerts
}
