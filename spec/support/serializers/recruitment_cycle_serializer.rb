class RecruitmentCycleSerializer < JSONAPI::Serializable::Resource
  type 'recruitment_cycles'

  has_many :providers

  attributes(*FactoryBot.attributes_for('recruitment_cycle').keys)
end
