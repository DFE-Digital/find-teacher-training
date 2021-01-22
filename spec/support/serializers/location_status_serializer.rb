class LocationStatusSerializer < JSONAPI::Serializable::Resource
  type 'location_statuses'

  has_one :location

  attributes(*FactoryBot.attributes_for('location_status').keys)
end
