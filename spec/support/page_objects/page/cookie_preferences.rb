module PageObjects
  module Page
    class CookiePreferences < SitePrism::Page
      set_url '/cookie_preferences'

      element :cookie_consent_accept, '#cookie-preferences-form-cookie-consent-true-field'
      element :cookie_consent_deny, '#cookie-preferences-form-cookie-consent-false-field'
    end
  end
end
