class SubjectAreaSerializer < JSONAPI::Serializable::Resource
  type 'subject_areas'

  has_many :subjects, foreign_key: :type
  attributes(*FactoryBot.attributes_for(:subject_area).keys)
end
