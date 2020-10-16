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
      source  = "thde/statuscake"
      version = "1.1.2"
    }
  }
  backend "azurerm" {
  }
}

module paas {
  source = "./modules/paas"

  cf_api_url                    = local.cf_api_url
  cf_user                       = var.paas_user
  cf_user_password              = var.paas_password
  cf_sso_passcode               = var.paas_sso_code
  app_environment               = var.paas_app_environment
  app_docker_image              = var.paas_app_docker_image
  web_app_instances             = var.paas_web_app_instances
  web_app_memory                = var.paas_web_app_memory
  rails_env                     = var.paas_rails_env
  sentry_dsn                    = var.paas_sentry_dsn
  secret_key_base               = var.paas_secret_key_base
  settings_cycle_ending_soon    = var.paas_settings_cycle_ending_soon
  settings_cycle_has_ended      = var.paas_settings_cycle_has_ended
  settings_display_apply_button = var.paas_settings_display_apply_button
  settings_google_gcp_api_key   = var.paas_settings_google_gcp_api_key
  settings_google_maps_api_key  = var.paas_settings_google_maps_api_key
  logstash_url                  = var.paas_logstash_url
}
