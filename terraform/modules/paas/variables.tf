variable cf_api_url {}

variable cf_user {}

variable cf_user_password {}

variable cf_sso_passcode {}

variable app_environment {}

variable app_docker_image {}

variable web_app_instances { default = 1 }

variable web_app_memory { default = 512 }

variable rails_env {}

variable sentry_dsn {}

variable secret_key_base {}

variable settings_cycle_ending_soon {}

variable settings_cycle_has_ended {}

variable settings_display_apply_button {}

variable settings_google_gcp_api_key {}

variable settings_google_maps_api_key {}

variable logstash_url {}


locals {
  web_app_name          = "find-${var.app_environment}"
  web_app_start_command = "bundle exec rails server -b 0.0.0.0"
  logging_service_name  = "find-logit-${var.app_environment}"
  app_environment_variables = {
    ASSETS_PRECOMPILE              = true
    AUTHORISED_HOSTS               = "${local.web_app_name}.london.cloudapps.digital"
    RAILS_ENV                      = var.rails_env
    RACK_ENV                       = var.rails_env
    RAILS_SERVE_STATIC_FILES       = true
    WEBPACKER_DEV_SERVER_HOST      = "webpacker"
    SECRET_KEY_BASE                = var.secret_key_base
    SENTRY_DSN                     = var.sentry_dsn
    SETTINGS__CYCLE_ENDING_SOON    = var.settings_cycle_ending_soon
    SETTINGS__CYCLE_HAS_ENDED      = var.settings_cycle_has_ended
    SETTINGS__DISPLAY_APPLY_BUTTON = var.settings_display_apply_button
    SETTINGS__GOOGLE__GCP_API_KEY  = var.settings_google_gcp_api_key
    SETTINGS__GOOGLE__MAPS_API_KEY = var.settings_google_maps_api_key
  }
}
