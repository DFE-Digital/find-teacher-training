variable cf_api_url {}

variable cf_user {}

variable cf_user_password {}

variable cf_sso_passcode {}

variable cf_space {}

variable app_environment {}

variable app_docker_image {}

variable web_app_instances { default = 1 }

variable web_app_memory { default = 512 }

variable redis_service_plan {}

variable logstash_url {}

variable app_environment_variables { type = map }

variable docker_credentials { type = map }

locals {
  web_app_name          = "find-${var.app_environment}"
  web_app_start_command = "bundle exec rails server -b 0.0.0.0"
  logging_service_name  = "find-logit-${var.app_environment}"
  redis_service_name    = "find-redis-${var.app_environment}"
  service_gov_uk_host_names = {
    qa       = ["qa"]
    staging  = ["staging"]
    sandbox  = ["sandbox"]
    prod     = ["www", "www2"]
  }
  web_app_service_gov_uk_route_ids = [for r in cloudfoundry_route.web_app_service_gov_uk_route : r.id]
  web_app_routes                   = concat(local.web_app_service_gov_uk_route_ids, [cloudfoundry_route.web_app_cloudapps_digital_route.id])
}
