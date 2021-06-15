module EmitRequestEvents
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    after_action :trigger_request_event
  end

  def trigger_request_event
    if FeatureFlag.active?(:send_web_requests_to_bigquery)
      request_event = Events::WebRequest.new
                        .with_request_details(request)
                        .with_response_details(response)

      SendEventToBigqueryJob.perform_later(request_event.as_json)
    end
  end
end
