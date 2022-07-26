module CurrentPointInRecruitmentCycleHelper
  def hint_text_for_mid_cycle
    "#{I18n.t('cycles.today_is_mid_cycle.description')} (#{CycleTimetable.find_opens.to_formatted_s(:govuk_date)} to #{CycleTimetable.apply_2_deadline.to_formatted_s(:govuk_date)})"
  end

  def hint_text_for_after_apply_1_deadline_passed
    "#{I18n.t('cycles.today_is_after_apply_1_deadline_passed.description')} (#{CycleTimetable.apply_1_deadline.to_formatted_s(:govuk_date)} to #{CycleTimetable.apply_2_deadline.to_formatted_s(:govuk_date)})"
  end

  def hint_text_for_after_apply_2_deadline_passed
    "#{I18n.t('cycles.today_is_after_apply_2_deadline_passed.description')} (#{CycleTimetable.apply_2_deadline.to_formatted_s(:govuk_date)} to #{CycleTimetable.find_closes.to_formatted_s(:govuk_date)})"
  end

  def hint_text_for_today_is_after_find_closes
    "#{I18n.t('cycles.today_is_after_find_closes.description')} (#{CycleTimetable.find_closes.to_formatted_s(:govuk_date)} to #{CycleTimetable.find_reopens.to_formatted_s(:govuk_date)})"
  end

  def hint_text_for_today_is_after_find_opens
    "#{I18n.t('cycles.today_is_after_find_opens.description')} (#{CycleTimetable.find_reopens.to_formatted_s(:govuk_date)})"
  end
end
