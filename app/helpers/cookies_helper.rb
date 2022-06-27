# frozen_string_literal: true

module CookiesHelper
  def hide_cookie_banner?
    cookies['consented-to-cookies'].present? || current_page?(cookie_preferences_path)
  end
end