# PaaS
paas_sso_code          = ""
paas_app_environment   = "staging"
paas_cf_space          = "bat-staging"
paas_web_app_instances = 2
paas_web_app_memory    = 512

# KeyVault
key_vault_name              = "s121t01-shared-kv-01"
key_vault_resource_group    = "s121t01-shared-rg"
key_vault_app_secret_name   = "FIND-APP-SECRETS-STAGING"
key_vault_infra_secret_name = "BAT-INFRA-SECRETS-STAGING"

#StatusCake
statuscake_alerts = {
  find-staging = {
    website_name   = "find-teacher-training-staging"
    website_url    = "https://staging.find-postgraduate-teacher-training.service.gov.uk/ping"
    test_type      = "HTTP"
    check_rate     = 60
    contact_group  = [188603]
    trigger_rate   = 0
    node_locations = ["UKINT", "UK1", "MAN1", "MAN5", "DUB2"]
  }
}
