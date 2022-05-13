require 'http'

class SlackNotificationJob < ApplicationJob
  def perform(text, url = nil)
    @webhook_url = Settings.STATE_CHANGE_SLACK_URL
    if @webhook_url.present?
      message = url.present? ? hyperlink(text, url) : text
      post_to_slack message
    end
  end

private

  def hyperlink(text, url)
    "<#{url}|#{text}>"
  end

  def post_to_slack(text)
    if HostingEnvironment.production?
      slack_message = text
      slack_channel = '#twd_apply_tech'
    else
      slack_message = "[#{HostingEnvironment.environment_name.upcase}] #{text}"
      slack_channel = '#twd_apply_test'
    end

    payload = {
      username: 'Find teacher training courses',
      channel: slack_channel,
      text: slack_message,
      mrkdwn: true,
      icon_emoji: ':livecanary:',
    }

    response = HTTP.post(@webhook_url, body: payload.to_json)

    unless response.status.success?
      raise SlackMessageError, "Slack error: #{response.body}"
    end
  end

  class SlackMessageError < StandardError; end
end
