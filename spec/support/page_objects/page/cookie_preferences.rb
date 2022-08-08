module PageObjects
  module Page
    class CookiePreferences < SitePrism::Page
      set_url '/cookies'

      element :analytics_cookie_accept, '#cookie-preferences-form-analytics-consent-true-field'
      element :analytics_cookie_deny, '#cookie-preferences-form-analytics-consent-false-field'
      element :marketing_cookie_accept, '#cookie-preferences-form-marketing-consent-true-field'
      element :marketing_cookie_deny, '#cookie-preferences-form-marketing-consent-false-field'
    end
  end
end
