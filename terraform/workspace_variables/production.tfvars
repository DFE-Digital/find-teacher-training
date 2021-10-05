# PaaS
paas_sso_code               = ""
paas_app_environment        = "prod"
paas_app_environment_config = "prod"
paas_cf_space               = "bat-prod"
paas_web_app_host_name      = "www"
paas_web_app_instances      = 15
paas_web_app_memory         = 2048
paas_worker_app_instances   = 2
paas_worker_app_memory      = 1024
paas_redis_service_plan     = "micro-ha-5_x"

# KeyVault
key_vault_resource_group = "s121p01-shared-rg"

#StatusCake
statuscake_alerts = {
  find-prod = {
    website_name   = "find-teacher-training-prod"
    website_url    = "https://www.find-postgraduate-teacher-training.service.gov.uk/ping"
    test_type      = "HTTP"
    check_rate     = 60
    contact_group  = [151103]
    trigger_rate   = 0
    node_locations = ["UKINT", "UK1", "MAN1", "MAN5", "DUB2"]
  }
}
