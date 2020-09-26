data cloudfoundry_org org {
  name = "dfe-teacher-services"
}

data cloudfoundry_space space {
  name = "bat-${var.app_environment}"
  org  = data.cloudfoundry_org.org.id
}

data cloudfoundry_domain cloudapps_digital {
  name = "london.cloudapps.digital"
}
