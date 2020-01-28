class SiteSerializer < JSONAPI::Serializable::Resource
  type "sites"

  has_many :providers

  attributes(*FactoryBot.attributes_for("site").keys)
end
