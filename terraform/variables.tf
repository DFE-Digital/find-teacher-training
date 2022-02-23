variable paas_sso_code { default = "" }

variable paas_cf_space {}

variable paas_app_environment {}

variable paas_app_environment_config {}

variable paas_app_docker_image {}

variable paas_web_app_host_name {}

variable paas_web_app_instances { default = 1 }

variable paas_web_app_memory { default = 512 }

variable paas_worker_app_instances { default = 1 }

variable paas_worker_app_memory { default = 512 }

variable paas_redis_service_plan {}

variable paas_app_config_file { default = "./workspace_variables/app_config.yml" }

variable key_vault_name {}

variable key_vault_resource_group {}

variable key_vault_app_secret_name {}

variable key_vault_infra_secret_name {}

variable azure_credentials { default = null }

#StatusCake
variable statuscake_alerts {
  type    = map
  default = {}
}

locals {
  cf_api_url                     = "https://api.london.cloud.service.gov.uk"
  app_config                     = yamldecode(file(var.paas_app_config_file))[var.paas_app_environment_config]
  app_secrets                    = yamldecode(data.azurerm_key_vault_secret.app_secrets.value)
  infra_secrets                  = yamldecode(data.azurerm_key_vault_secret.infra_secrets.value)
  paas_app_environment_variables = merge(local.app_config, local.app_secrets)
  azure_credentials = try(jsondecode(var.azure_credentials), null)
}
