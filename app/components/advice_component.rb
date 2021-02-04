class AdviceComponent < ViewComponent::Base
  include ViewHelper

  attr_reader :title

  def initialize(title:)
    @title = title
  end
end
