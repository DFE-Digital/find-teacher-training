class LocationSerializer < JSONAPI::Serializable::Resource
  type 'locations'

  belongs_to :provider

  belongs_to :location_status

  attributes(*FactoryBot.attributes_for('location').keys)
end
