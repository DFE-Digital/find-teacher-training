class ProviderDecorator < Draper::Decorator
  delegate_all

  def short_address
    address_lines.join(', ')
  end

  def full_address
    address_lines.map { |line| ERB::Util.html_escape(line) }.join('<br> ').html_safe
  end

  def website
    return if object.website.blank?

    object.website.start_with?('http') ? object.website : ('http://' + object.website)
  end

private

  def address_lines
    [
      object.street_address_1,
      object.street_address_2,
      object.city,
      object.county,
      object.postcode,
    ].reject(&:blank?)
  end
end
