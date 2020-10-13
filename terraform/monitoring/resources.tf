module prometheus_all {
  source = "git::https://github.com/DFE-Digital/bat-platform-building-blocks.git//terraform/modules/prometheus_all?ref=monitoring-terraform-0_13"

  enabled_modules = ["paas_prometheus_exporter", "prometheus", "grafana"]

  paas_user     = var.paas_user
  paas_password = var.paas_password
  paas_sso_code = var.paas_sso_code

  monitoring_org_name   = local.monitoring_org_name
  monitoring_space_name = local.monitoring_space_name

  paas_exporter_config = {
    API_ENDPOINT = local.paas_api_url
    USERNAME     = var.paas_exporter_username
    PASSWORD     = var.paas_exporter_password
  }

  grafana_config = {
    dashboard_directory  = "./files"
    google_client_id     = var.grafana_google_client_id
    google_client_secret = var.grafana_google_client_secret
  }
  grafana_admin_password = var.grafana_admin_password
}
