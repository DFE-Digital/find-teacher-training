class HeartbeatController < ActionController::API
  def ping
    render body: 'PONG'
  end

  def healthcheck
    checks = {
      teacher_training_api: api_alive?,
    }

    render status: (checks.values.all? ? :ok : :service_unavailable),
           json: {
             checks:,
           }
  end

  def sha
    render json: { sha: ENV.fetch('SHA', nil) }
  end

private

  def api_alive?
    response = Faraday.get("#{Settings.teacher_training_api.base_url}/healthcheck")
    response.success?
  rescue StandardError
    false
  end
end
