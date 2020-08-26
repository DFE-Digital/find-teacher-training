alerts =  {
ftt = {
    website_name = "prod-find-postgraduate-teacher-training"
    website_url   = "https://www.find-postgraduate-teacher-training.service.gov.uk/ping"
    test_type     = "HTTP"
    check_rate    = 60
    contact_group = [151103]
    trigger_rate  = 0
    custom_header = "{\"Content-Type\": \"application/x-www-form-urlencoded\"}"
    status_codes  = "204, 205, 206, 303, 400, 401, 403, 404, 405, 406, 408, 410, 413, 444, 429, 494, 495, 496, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 521, 522, 523, 524, 520, 598, 599"
  }
}
