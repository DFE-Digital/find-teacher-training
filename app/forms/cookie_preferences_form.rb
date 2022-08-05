class CookiePreferencesForm
  include ActiveModel::Model

  attr_accessor :cookie_consent, :cookies, :cookie_name, :expiry_date

  validates :cookie_consent, presence: true, inclusion: { in: %w[true false] }

  def initialize(cookies, params = {})
    @cookies = cookies
    @cookie_name = Settings.cookies.consent.name
    @expiry_date = Settings.cookies.consent.expire_after_days.days.from_now
    @cookie_consent = params[:cookie_consent] || cookies[cookie_name]
  end

  def save
    if valid?
      cookies[cookie_name] = { value: cookie_consent, expires: expiry_date }
    end
  end
end
