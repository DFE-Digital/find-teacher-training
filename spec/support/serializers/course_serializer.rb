class CourseSerializer < JSONAPI::Serializable::Resource
  type "courses"

  belongs_to :provider
  belongs_to :accrediting_provider
  belongs_to :recruitment_cycle, through: :provider

  has_many :site_statuses
  has_many :sites
  has_many :subjects

  attributes(*FactoryBot.attributes_for("course").keys)

  # belongs_to need to have their attributes declared or they don't serialise
  # correctly
  attribute :provider
  attribute :provider_code
  attribute :recruitment_cycle
  attribute :recruitment_cycle_year
  attribute :funding_type
end
