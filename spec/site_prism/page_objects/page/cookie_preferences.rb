module PageObjects
  module Page
    class CookiePreferences < SitePrism::Page
      set_url "/cookie_preferences"

      element :cookie_consent_accept, '[data-qa="cookie-consent-accept"]'
      element :cookie_consent_deny, '[data-qa="cookie-consent-deny"]'
    end
  end
end
