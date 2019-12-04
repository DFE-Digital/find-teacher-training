FactoryBot.define do
  factory :course do
    sequence(:id)
    sequence(:course_code) { |n| "X10#{n}" }
    name { "English" }
  end
end
