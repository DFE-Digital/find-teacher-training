# frozen_string_literal: true

module CookiesHelper
  def hide_cookie_banner?
    cookies[Settings.cookies.consent.name].present? || current_page?(cookie_preferences_path)
  end
end
