# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :store_request_id

  def store_request_id
    RequestStore.store[:request_id] = request.uuid
  end

  def assign_sentry_contexts
    Raven.extra_context(request_id: RequestStore.store[:request_id])
  end

  def append_info_to_payload(payload)
    super

    payload[:request_id] = RequestStore.store[:request_id]
  end
end
