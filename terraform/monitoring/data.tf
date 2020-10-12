data cloudfoundry_org org {
  name = "dfe-teacher-services"
}

data cloudfoundry_space monitoring {
  name = local.monitoring_space_name
  org  = data.cloudfoundry_org.org.id
}

data cloudfoundry_domain cloudapps {
  name = "london.cloudapps.digital"
}
