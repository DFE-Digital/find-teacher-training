# PaaS
paas_sso_code          = ""
paas_app_environment   = "prod"
paas_cf_space          = "bat-prod"
paas_web_app_instances = 2
paas_web_app_memory    = 1024

# KeyVault
key_vault_name              = "s121p01-shared-kv-01"
key_vault_resource_group    = "s121p01-shared-rg"
key_vault_app_secret_name   = "FIND-APP-SECRETS-PRODUCTION"
key_vault_infra_secret_name = "BAT-INFRA-SECRETS-PRODUCTION"

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
