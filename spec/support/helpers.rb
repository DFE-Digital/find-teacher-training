module Helpers
  def stub_omniauth(user: nil, provider: nil)
    user ||= build(:user)
    provider ||= build(:provider)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:dfe] = {
      "provider" => "dfe",
      "uid"      => SecureRandom.uuid,
      "info"     => {
        "first_name" => user.first_name,
        "last_name"  => user.last_name,
        "email"      => user.email,
        "id"         => user.id,
        "state"      => user.state,
        "admin"      => user.admin,
      },
      "credentials" => {
        "token_id" => "123",
      },
    }

    # This is needed because we check the provider count on all pages
    # TODO: Move this to be returned with the user.
    stub_api_v2_request(
      "/recruitment_cycles/#{Settings.current_cycle}/providers",
      provider.to_jsonapi,
    )
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:dfe]
    stub_api_v2_request("/sessions", user.to_jsonapi, :post)

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

    stub_api_v2_request("/sessions", user.to_jsonapi, :post)

    begin
      Settings[:authorised_user] = authorised_user
      yield
    ensure
      Settings.delete_field(:authorised_user)
    end
  end

  def stub_api_v2_request(url_path, stub, method = :get, status = 200, token: nil, body: nil, &validate_request_body)
    url = "#{Settings.manage_backend.base_url}/api/v2#{url_path}"

    stubbed_request = stub_request(method, url)
                        .to_return(
                          status: status,
                          body: stub.to_json,
                          headers: { 'Content-Type': "application/vnd.api+json" },
                        )
    if body
      stubbed_request.with(body: body)
    end

    if token
      stubbed_request.with(
        headers: {
          "Accept"          => "application/vnd.api+json",
          "Accept-Encoding" => "gzip,deflate",
          "Authorization"   => "Bearer #{token}",
          "Content-Type"    => "application/vnd.api+json",
          "User-Agent"      => "Faraday v#{Faraday::VERSION}",
        },
      )
    end

    if validate_request_body
      stubbed_request.with do |request|
        request_body_json = JSON.parse(request.body)
        validate_request_body.call(request_body_json)
      end
    end

    stubbed_request
  end

  def stub_api_v2_resource(resource,
                           jsonapi_response: nil,
                           include: nil,
                           method: :get,
                           &validate_request_body)
    query_params = {}
    query_params[:include] = include if include.present?

    if method.in?(%i[get patch])
      url = url_for_resource(resource)
    elsif method == :post
      url = url_for_resource_collection(resource)
    end

    url += "?#{query_params.to_param}" if query_params.any?

    jsonapi_response ||= resource.to_jsonapi(include: include)
    stub_api_v2_request(url, jsonapi_response, method, &validate_request_body)
  end

  def stub_api_v2_new_resource(resource, jsonapi_response = nil)
    url = url_for_new_resource(resource)

    jsonapi_response ||= resource.to_jsonapi
    stub_api_v2_request(url, jsonapi_response)
  end

  def stub_api_v2_resource_collection(resources,
                                      endpoint: nil,
                                      jsonapi_response: nil,
                                      include: nil)
    query_params = {}
    query_params[:include] = include if include.present?


    if endpoint.nil?
      endpoint = url_for_resource_collection(resources.first)
      endpoint += "?#{query_params.to_param}" if query_params.any?
    end

    jsonapi_response ||= resource_list_to_jsonapi(resources, include: include)
    stub_api_v2_request(endpoint, jsonapi_response)
  end

  def stub_api_v2_empty_resource_collection(resource,
                                            child_resource,
                                            jsonapi_response: nil)
    url = url_for_resource(resource) + "/#{child_resource}"

    jsonapi_response ||= resource_list_to_jsonapi([])
    stub_api_v2_request(url, jsonapi_response)
  end

  def stub_api_v2_build_course(params = {})
    jsonapi_response = course.to_jsonapi(include: [:subjects, :sites, :provider, :accrediting_provider, provider: [:sites]])
    jsonapi_response[:data][:meta] = course.meta
    jsonapi_response[:data][:errors] = course_errors_to_json_api(course)
    stub_api_v2_request(
      url_for_build_course_with_params(params),
      jsonapi_response,
    )
  end

  def disable_authorised_development_user
    allow(Settings).to receive(:key?).with(:authorised_user).and_return(false)
  end

private

  def course_errors_to_json_api(course)
    errors = []
    course.errors.messages.each do |error_key, _|
      course.errors.full_messages_for(error_key).each do |error_message|
        errors << {
          "title" => "Invalid #{error_key}",
          "detail" => error_message,
          "source" => { "pointer" => "/data/attributes/#{error_key}" },
        }
      end
    end
    errors
  end

  def url_for_resource(resource)
    base_url = url_for_resource_collection(resource)
    id = resource[resource.class.primary_key]
    "#{base_url}/#{id}"
  end

  def url_for_resource_collection(resource)
    if resource.is_a? RecruitmentCycle
      "/recruitment_cycles"
    elsif resource.is_a? Provider
      url_for_resource(resource.recruitment_cycle) + "/providers"
    elsif resource.is_a? Course
      url_for_resource(resource.provider) + "/courses"
    elsif resource.is_a? AccessRequest
      "/access_requests"
    elsif resource.is_a? Organisation
      "/organisations"
    else
      raise "Resource '#{resource.class}' was not found. Add to 'url_for_resource_collection' helper."
    end
  end

  def url_for_new_resource(resource)
    base_url = url_for_resource_collection(resource)
    "#{base_url}/new"
  end

  def url_for_build_course_with_params(params)
    provider_code = provider.provider_code
    recruitment_cycle_year = provider.recruitment_cycle_year
    url = "/build_new_course?" \
      "provider_code=#{provider_code}&recruitment_cycle_year=#{recruitment_cycle_year}&"

    url + params.to_query("course")
  end
end

RSpec.configure do |config|
  config.include Helpers
end
