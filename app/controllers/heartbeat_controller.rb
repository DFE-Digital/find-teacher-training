class HeartbeatController < ActionController::API
  include HTTParty

  def healthcheck
    checks = {
        teacher_training_api: api_alive?,
    }

    status = :ok
    status = :bad_gateway unless checks.values.all?
    render status: status, json: {
      checks: checks,
    }
  end

private

  def api_alive?
    response = HeartbeatController.get("#{Settings.teacher_training_api.base_url}/healthcheck")
    response.success?
  rescue StandardError
    false
  end
end
