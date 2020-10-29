variable paas_user {}

variable paas_password {}

variable paas_sso_code {}

variable paas_app_environment {}

variable paas_app_docker_image {}

variable paas_web_app_instances { default = 1 }

variable paas_web_app_memory { default = 512 }

variable paas_logstash_url {}

variable paas_app_config_file { default = "./workspace_variables/app_config.yml" }

variable paas_app_secrets_file { default = "./app_secrets.yml" }

variable dockerhub_username {}

variable dockerhub_password {}

locals {
  cf_api_url                     = "https://api.london.cloud.service.gov.uk"
  app_config                     = yamldecode(file(var.paas_app_config_file))[var.paas_app_environment]
  app_secrets                    = yamldecode(file(var.paas_app_secrets_file))
  paas_app_environment_variables = merge(local.app_config, local.app_secrets)
  docker_credentials = {
    username = var.dockerhub_username
    password = var.dockerhub_password
  }
}
