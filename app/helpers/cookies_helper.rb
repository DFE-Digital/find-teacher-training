# frozen_string_literal: true

module CookiesHelper
  def hide_cookie_banner?
    cookies[Settings.cookies.analytics.name].present? || current_page?(cookie_preferences_path)
  end

  def marketing_ads_allowed?
    cookies[Settings.cookies.marketing.name].present?
  end
end
