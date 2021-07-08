module Events
  class WebRequest
    def initialize
      @event_hash = {
        occurred_at: Time.zone.now.iso8601,
        environment: Rails.env,
        event_type: 'web_request',
      }
    end

    def as_json
      @event_hash.as_json
    end

    def with_request_details(rack_request)
      @event_hash.deep_merge!(
        request_uuid: rack_request.uuid,
        request_path: rack_request.path,
        request_method: rack_request.method,
        request_user_agent: rack_request.user_agent,
        request_referer: rack_request.referer,
        request_query: query_to_kv_pairs(rack_request.query_string),
        anonymised_user_agent_and_ip: anonymise(rack_request.user_agent.to_s + rack_request.remote_ip.to_s),
      )

      self
    end

    def with_response_details(response)
      @event_hash.deep_merge!(
        response_status: response.status,
        response_content_type: response.content_type,
      )

      self
    end

  private

    def query_to_kv_pairs(query_string)
      vars = Rack::Utils.parse_query(query_string)
      vars.map do |(key, value)|
        { 'key' => key, 'value' => Array.wrap(value) }
      end
    end

    def anonymise(text)
      Digest::SHA2.hexdigest(text)
    end
  end
end
