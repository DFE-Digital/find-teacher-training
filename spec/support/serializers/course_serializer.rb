class CourseSerializer < JSONAPI::Serializable::Resource
  type "courses"

  belongs_to :provider
  belongs_to :recruitment_cycle, through: :provider

  attributes(*FactoryBot.attributes_for("course").keys)

  # belongs_to need to have their attributes declared or they don't serialise
  # correctly
  attribute :provider
  attribute :provider_code
  attribute :recruitment_cycle
  attribute :recruitment_cycle_year
end
