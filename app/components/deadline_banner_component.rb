class DeadlineBannerComponent < ViewComponent::Base
  attr_accessor :flash_empty

  def initialize(flash_empty:)
    @flash_empty = flash_empty
  end

  def render?
    flash_empty && !CycleTimetable.find_down?
  end

private

  def apply_1_deadline
    CycleTimetable.apply_1_deadline.to_formatted_s(:govuk_date_and_time)
  end

  def apply_2_deadline
    CycleTimetable.apply_2_deadline.to_formatted_s(:govuk_date_and_time)
  end

  def find_opens
    CycleTimetable.find_opens.to_formatted_s(:month_and_year)
  end

  def find_reopens
    CycleTimetable.find_reopens.to_formatted_s(:govuk_date_and_time)
  end

  def apply_reopens
    CycleTimetable.apply_reopens.to_formatted_s(:govuk_date_and_time)
  end
end
