terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.15.5"
    }
  }
}

provider cloudfoundry {
  api_url           = var.cf_api_url
  user              = var.cf_sso_passcode == "" ? var.cf_user : null
  password          = var.cf_sso_passcode == "" ? var.cf_user_password : null
  sso_passcode      = var.cf_sso_passcode != "" ? var.cf_sso_passcode : null
  store_tokens_path = var.cf_sso_passcode != "" ? ".cftoken" : null
}

resource cloudfoundry_app web_app {
  name                       = local.web_app_name
  command                    = local.web_app_start_command
  docker_image               = var.app_docker_image
  health_check_type          = "http"
  health_check_http_endpoint = "/ping"
  instances                  = var.web_app_instances
  memory                     = var.web_app_memory
  space                      = data.cloudfoundry_space.space.id
  strategy                   = "blue-green-v2"
  timeout                    = 180
  environment                = local.app_environment_variables
  dynamic "routes" {
    for_each = local.web_app_routes
    content {
      route = routes.value
    }
  }

  dynamic "service_binding" {
    for_each = local.logging_service_bindings
    content {
      service_instance = service_binding.value
    }
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.redis.id
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.cache_redis.id
  }
}

resource cloudfoundry_app worker_app {
  name               = local.worker_app_name
  command            = local.worker_app_start_command
  docker_image       = var.app_docker_image
  health_check_type  = "process"
  instances          = var.worker_app_instances
  memory             = var.worker_app_memory
  space              = data.cloudfoundry_space.space.id
  strategy           = "blue-green-v2"
  timeout            = 180
  environment        = local.app_environment_variables

  dynamic "service_binding" {
    for_each = local.logging_service_bindings
    content {
      service_instance = service_binding.value
    }
  }

  service_binding {
    service_instance = cloudfoundry_service_instance.redis.id
  }
  service_binding {
    service_instance = cloudfoundry_service_instance.cache_redis.id
  }
}

resource cloudfoundry_route web_app_cloudapps_digital_route {
  domain   = data.cloudfoundry_domain.london_cloudapps_digital.id
  space    = data.cloudfoundry_space.space.id
  hostname = local.web_app_name
}

resource cloudfoundry_route web_app_service_gov_uk_route {
  domain   = data.cloudfoundry_domain.find_service_gov_uk.id
  space    = data.cloudfoundry_space.space.id
  hostname = local.service_gov_uk_host_names[var.app_environment_config]
}

resource "cloudfoundry_route" "web_app_assets_service_gov_uk_route" {
  domain   = data.cloudfoundry_domain.find_service_gov_uk.id
  space    = data.cloudfoundry_space.space.id
  hostname = local.assets_host_names[var.app_environment_config]
}

resource cloudfoundry_user_provided_service logging {
  name             = local.logging_service_name
  space            = data.cloudfoundry_space.space.id
  syslog_drain_url = var.logstash_url
}

resource "cloudfoundry_service_instance" "redis" {
  name         = local.worker_redis_service_name
  space        = data.cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.redis.service_plans[var.redis_service_plan]
  json_params  = jsonencode({ maxmemory_policy = "noeviction" })
  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "cloudfoundry_service_instance" "cache_redis" {
  name         = local.cache_redis_service_name
  space        = data.cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.redis.service_plans[var.redis_service_plan]
  json_params  = jsonencode({ maxmemory_policy = "allkeys-lru" })
  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "cloudfoundry_service_key" "cache_redis_key" {
  name             = "${local.cache_redis_service_name}-key"
  service_instance = cloudfoundry_service_instance.cache_redis.id
}

resource "cloudfoundry_service_key" "worker_redis_key" {
  name             = "${local.worker_redis_service_name}-key"
  service_instance = cloudfoundry_service_instance.redis.id
}
