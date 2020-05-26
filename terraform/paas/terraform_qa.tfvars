app = {
  name         = "qa-find-postgraduate-teacher-training"
  docker_image = "dfedigital/find-teacher-training:latest"
  hostname     = "qa-find-postgraduate-teacher-training"
  space        = "find-qa"
}

app_env = {
  ASSETS_PRECOMPILE                                = true
  RAILS_ENV                                        = "qa"
  RAILS_SERVE_STATIC_FILES                         = true
  SETTINGS__REDIRECT_RESULTS_TO_C_SHARP            = false
  WEBPACKER_DEV_SERVER_HOST                        = "webpacker"
  WEBSITE_SLOT_POLL_WORKER_FOR_CHANGE_NOTIFICATION = "0"
}
