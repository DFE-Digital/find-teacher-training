variable paas_user {}

variable paas_password {}

variable paas_sso_code {}

variable paas_app_environment {}

variable paas_app_docker_image {}

variable paas_web_app_instances { default = 1 }

variable paas_web_app_memory { default = 512 }

variable paas_rails_env {}

variable paas_sentry_dsn {}

variable paas_secret_key_base {}

variable paas_settings_cycle_ending_soon {}

variable paas_settings_cycle_has_ended {}

variable paas_settings_display_apply_button {}

variable paas_settings_google_gcp_api_key {}

variable paas_settings_google_maps_api_key {}

variable paas_settings_logstash_host {}

variable paas_settings_logstash_port {}

locals {
  cf_api_url = "https://api.london.cloud.service.gov.uk"
}
