class FeedbackComponent < ViewComponent::Base
  include ViewHelper

  attr_reader :path, :original_controller

  def initialize(path:, original_controller:)
    @path = path
    @original_controller = original_controller
  end
end
