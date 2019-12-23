class SiteStatusSerializer < JSONAPI::Serializable::Resource
  type "site_statuses"

  attributes(*FactoryBot.attributes_for("site_status").keys)

  has_one :site
end
