module Helpers
  def stub_omniauth(user: nil, provider: nil)
    user ||= build(:user)
    provider ||= build(:provider)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:dfe] = {
      "provider" => "dfe",
      "uid" => SecureRandom.uuid,
      "info" => {
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "email" => user.email,
        "id" => user.id,
        "state" => user.state,
        "admin" => user.admin,
      },
      "credentials" => {
        "token_id" => "123",
      },
    }

    # This is needed because we check the provider count on all pages
    # TODO: Move this to be returned with the user.
    stub_api_v2_request(
      "/recruitment_cycles/#{Settings.current_cycle}/providers",
      resource_to_jsonapi(provider),
    )
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:dfe]
    stub_api_v2_request("/sessions", resource_to_jsonapi(user), :post)

    disable_authorised_development_user
  end

  def stub_authorised_development_user(user)
    raise <<~EOMESSAGE unless block_given?
      Can only stub authorised_user with a block, for example:

        stub_authorised_development_user(user) do
          get "/organisations"
        end
    EOMESSAGE

    authorised_user = Config::Options.new(
      email: user.email,
      password: user.password,
      first_name: user.first_name,
      last_name: user.last_name,
    )

    stub_api_v2_request("/sessions", resource_to_jsonapi(user), :post)

    begin
      Settings[:authorised_user] = authorised_user
      yield
    ensure
      Settings.delete_field(:authorised_user)
    end
  end

  def disable_authorised_development_user
    allow(Settings).to receive(:key?).with(:authorised_user).and_return(false)
  end

  def expect_page_to_be_displayed_with_query(page:, expected_query_params:)
    current_query_string = URI(current_url).query
    expect(page).to be_displayed
    expect(Rack::Utils.parse_nested_query(current_query_string)).to eq(expected_query_params)
  end
end

RSpec.configure do |config|
  config.include Helpers
end
