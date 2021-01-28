# PaaS
paas_sso_code          = ""
paas_app_environment   = "staging"
paas_cf_space          = "bat-staging"
paas_web_app_instances = 2
paas_web_app_memory    = 512

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
