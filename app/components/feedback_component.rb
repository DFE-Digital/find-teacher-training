class FeedbackComponent < ViewComponent::Base
  include ViewHelper

  attr_reader :path, :controller

  def initialize(path:, controller:)
    @path = path
    @controller = controller
  end
end
