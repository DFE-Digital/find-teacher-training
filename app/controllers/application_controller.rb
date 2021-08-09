# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include EmitRequestEvents

  before_action :store_request_id
  before_action :assign_sentry_contexts
  before_action :redirect_to_cycle_has_ended_if_find_is_down

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  def store_request_id
    RequestStore.store[:request_id] = request.uuid
  end

  def assign_sentry_contexts
    Raven.tags_context(request_id: RequestStore.store[:request_id])
  end

  def append_info_to_payload(payload)
    super

    payload[:request_id] = RequestStore.store[:request_id]
  end

  def render_feedback_component
    @render_feedback_component = true
  end

private

  def redirect_to_cycle_has_ended_if_find_is_down
    redirect_to cycle_has_ended_path if CycleTimetable.find_down?
  end
end
