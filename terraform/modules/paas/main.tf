terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.12.4"
    }
  }
}

provider cloudfoundry {
  api_url      = var.cf_api_url
  user         = var.cf_user != "" ? var.cf_user : null
  password     = var.cf_user_password != "" ? var.cf_user_password : null
  sso_passcode = var.cf_sso_passcode != "" ? var.cf_sso_passcode : null
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
  routes {
    route = cloudfoundry_route.web_app_route.id
  }
  service_binding {
    service_instance = cloudfoundry_user_provided_service.logging.id
  }
}

resource cloudfoundry_route web_app_route {
  domain   = data.cloudfoundry_domain.cloudapps_digital.id
  space    = data.cloudfoundry_space.space.id
  hostname = local.web_app_name
}

resource cloudfoundry_user_provided_service logging {
  name             = local.logging_service_name
  space            = data.cloudfoundry_space.space.id
  syslog_drain_url = "${var.settings_logstash_host}:${var.settings_logstash_port}"
}
