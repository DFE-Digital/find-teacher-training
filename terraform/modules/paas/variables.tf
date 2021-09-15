variable cf_api_url {}

variable cf_user { default = null }

variable cf_user_password { default = null }

variable cf_sso_passcode { default = "" }

variable cf_space {}

variable app_environment {}

variable app_environment_config {}

variable app_docker_image {}

variable web_app_host_name {}

variable web_app_instances { default = 1 }

variable web_app_memory { default = 512 }

variable worker_app_instances { default = 1 }

variable worker_app_memory { default = 512 }

variable redis_service_plan {}

variable logstash_url {}

variable app_environment_variables { type = map }

variable docker_credentials { type = map }

locals {
  app_name_suffix          = var.app_environment_config != "review" ? var.app_environment : "pr-${var.web_app_host_name}"
  web_app_name             = "find-${local.app_name_suffix}"
  worker_app_name          = "find-worker-${local.app_name_suffix}"
  web_app_start_command    = "bundle exec rails server -b 0.0.0.0"
  worker_app_start_command = "bundle exec sidekiq -c 5 -C config/sidekiq.yml"
  logging_service_name     = "find-logit-${local.app_name_suffix}"
  redis_service_name       = "find-redis-${local.app_name_suffix}"
  service_gov_uk_host_names = {
    qa      = ["qa"]
    staging = ["staging"]
    sandbox = ["sandbox"]
    prod    = ["www", "www2"]
    review  = [local.app_name_suffix]
  }
  assets_host_names = {
    qa        = "qa-assets"
    staging   = "staging-assets"
    sandbox   = "sandbox-assets"
    load-test = "assets"
    prod      = "assets"
    review    = "${local.app_name_suffix}-assets"
  }
  web_app_service_gov_uk_route_ids = [for r in cloudfoundry_route.web_app_service_gov_uk_route : r.id]
  web_app_routes = concat(local.web_app_service_gov_uk_route_ids,
  [cloudfoundry_route.web_app_cloudapps_digital_route.id, cloudfoundry_route.web_app_assets_service_gov_uk_route.id])
}
