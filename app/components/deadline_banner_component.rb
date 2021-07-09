class DeadlineBannerComponent < ViewComponent::Base
  attr_accessor :flash_empty

  def initialize(flash_empty:)
    @flash_empty = flash_empty
  end

  def render?
    flash_empty
  end

private

  def apply_1_deadline
    CycleTimetable.apply_1_deadline.strftime('%e %B %Y')
  end

  def apply_2_deadline
    CycleTimetable.apply_2_deadline.strftime('%e %B %Y')
  end

  def find_reopens
    CycleTimetable.find_reopens.strftime('%e %B %Y')
  end

  def apply_reopens
    CycleTimetable.apply_reopens.strftime('%e %B %Y')
  end
end
