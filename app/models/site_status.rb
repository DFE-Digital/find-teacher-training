class SiteStatus < Base
  def new_or_running?
    status.in?(%w[running new_status])
  end
end
