require 'rails_helper'

RSpec.describe '/cycles', type: :request do
  context "when cycle selected is 'today_is_after_find_opens'" do
    it "sets recruitment cycle year to #{CycleTimetable.next_year}" do
      post '/cycles', params: { change_cycle_form: { cycle_schedule_name: 'today_is_after_find_opens' } }

      expect(SiteSetting.recruitment_cycle_year).to eq(CycleTimetable.next_year.to_s)
    end
  end

  context "when cycle selected is anything other than 'today_is_after_find_opens'" do
    it "sets recruitment cycle year to #{CycleTimetable.current_year}" do
      post '/cycles', params: { change_cycle_form: { cycle_schedule_name: 'today_is_mid_cycle' } }

      expect(SiteSetting.recruitment_cycle_year).to eq(CycleTimetable.current_year.to_s)
    end
  end
end
