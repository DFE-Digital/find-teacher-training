class Location < Base
  belongs_to :recruitment_cycle, through: :provider, param: :recruitment_cycle_year
  belongs_to :provider, param: :provider_code
  belongs_to :course, param: :course_code

  properties :code,
             :name,
             :street_address_1,
             :street_address_2,
             :city,
             :county,
             :postcode,
             :latitude,
             :longitude

  def address_blank?
    # Locations that have no address details whatsoever are not to be considered
    # when calculating '#nearest_address' or '#location_distance'
    [street_address_1, street_address_2, city, county, postcode].all?(&:blank?)
  end

  def coordinates_blank?
    latitude.blank? || longitude.blank?
  end
end
