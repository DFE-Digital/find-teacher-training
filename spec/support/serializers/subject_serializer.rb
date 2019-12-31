class SubjectSerializer < JSONAPI::Serializable::Resource
  type "subjects"

  attributes(*FactoryBot.attributes_for("subject").keys)
end
