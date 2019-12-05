FactoryBot.define do
  factory :recruitment_cycle do
    sequence(:id)
    year { Settings.current_cycle }
    application_start_date { "2018-10-09" }
  end
end
