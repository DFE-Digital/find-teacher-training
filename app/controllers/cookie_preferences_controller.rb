class CookiePreferencesController < ApplicationController
  def new; end

  def create
    if params[:cookie_consent].blank?
      flash[:error] = I18n.t("cookie_preferences.no_option_error")
      redirect_to(cookie_preferences_path)
    else
      user_preference = params[:cookie_consent]
      cookies["consented-to-cookies"] = { value: user_preference, expires: 6.months.from_now }

      flash[:success] = I18n.t("cookie_preferences.success")
      redirect_back(fallback_location: root_path)
    end
  end
end
