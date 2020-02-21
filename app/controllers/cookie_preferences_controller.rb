class CookiePreferencesController < ApplicationController
  def new; end

  def create
      user_preference = params[:cookie_consent]
      cookies["consented-to-cookies"] = { value: user_preference, expires: 6.months.from_now }
      redirect_back(fallback_location: root_path)
  end
end
