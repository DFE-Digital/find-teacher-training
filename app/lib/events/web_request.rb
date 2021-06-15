module Events
  class WebRequest
    def initialize
      @event_hash = {
        occured_at: Time.zone.now.iso8601,
        environment: Rails.env,
        event_type: 'web_request',
      }
    end

    def as_json
      @event_hash.as_json
    end

    def with_request_details(rack_request)
      @event_hash.merge!(
        request_uuid: rack_request.uuid,
        request_data: {
          path: rack_request.path,
          method: rack_request.method,
          user_agent: rack_request.user_agent,
        }
      )

      self
    end

    def with_response_details(response)
      @event_hash[:request_data][:status] = response.status

      self
    end
  end
end
