# PaaS
paas_sso_code           = ""
paas_app_environment    = "sandbox"
paas_cf_space           = "bat-prod"
paas_web_app_instances  = 2
paas_web_app_memory     = 512
paas_redis_service_plan = "micro-5_x"

# KeyVault
key_vault_resource_group    = "s121p01-shared-rg"

#StatusCake
statuscake_alerts = {
  find-sandbox = {
    website_name   = "find-teacher-training-sandbox"
    website_url    = "https://sandbox.find-postgraduate-teacher-training.service.gov.uk/ping"
    test_type      = "HTTP"
    check_rate     = 60
    contact_group  = [188603]
    trigger_rate   = 0
    node_locations = ["UKINT", "UK1", "MAN1", "MAN5", "DUB2"]
  }
}
