# PaaS
paas_sso_code          = ""
paas_app_environment   = "qa"
paas_web_app_instances = 1
paas_web_app_memory    = 512

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
