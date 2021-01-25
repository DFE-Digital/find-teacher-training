data cloudfoundry_org org {
  name = "dfe"
}

data cloudfoundry_space space {
  name = "bat-${var.app_environment}"
  org  = data.cloudfoundry_org.org.id
}

data cloudfoundry_domain london_cloudapps_digital {
  name = "london.cloudapps.digital"
}

data cloudfoundry_domain find_service_gov_uk {
  name = "find-postgraduate-teacher-training.service.gov.uk"
}
