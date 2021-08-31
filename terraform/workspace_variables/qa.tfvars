# PaaS
paas_sso_code               = ""
paas_app_environment        = "qa"
paas_app_environment_config = "qa"
paas_cf_space               = "bat-qa"
paas_web_app_instances      = 1
paas_web_app_host_name      = "qa"
paas_web_app_memory         = 512
paas_worker_app_instances   = 1
paas_worker_app_memory      = 512
paas_redis_service_plan     = "micro-5_x"

# KeyVault
key_vault_resource_group = "s121d01-shared-rg"

#StatusCake
statuscake_alerts = {
  find-qa = {
    website_name   = "find-teacher-training-qa"
    website_url    = "https://qa.find-postgraduate-teacher-training.service.gov.uk/ping"
    test_type      = "HTTP"
    check_rate     = 60
    contact_group  = [188603]
    trigger_rate   = 0
    node_locations = ["UKINT", "UK1", "MAN1", "MAN5", "DUB2"]
  }
}
