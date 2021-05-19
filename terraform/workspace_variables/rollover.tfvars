# PaaS
paas_sso_code          = ""
paas_app_environment   = "rollover"
paas_cf_space          = "bat-staging"
paas_web_app_instances = 2
paas_web_app_memory    = 512

# KeyVault
key_vault_resource_group = "s121t01-shared-rg"

#StatusCake
statuscake_alerts = {
  find-rollover = {
    website_name   = "find-teacher-training-rollover"
    website_url    = "https://find-rollover.london.cloudapps.digital/ping"
    test_type      = "HTTP"
    check_rate     = 60
    contact_group  = [188603]
    trigger_rate   = 0
    node_locations = ["UKINT", "UK1", "MAN1", "MAN5", "DUB2"]
  }
}
