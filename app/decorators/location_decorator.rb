class LocationDecorator < Draper::Decorator
  delegate_all

  def full_address
    [
      object.street_address_1,
      object.street_address_2,
      object.city,
      object.county,
      object.postcode,
    ].select(&:present?)
     .join(', ')
     .html_safe
  end
end
