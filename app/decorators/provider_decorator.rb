class ProviderDecorator < Draper::Decorator
  delegate_all

  def full_address
    [object.address1, object.address2, object.address3, object.address4, object.postcode].select(&:present?).join("<br> ").html_safe
  end

  def website
    return if object.website.blank?

    object.website.start_with?("http") ? object.website : ("http://" + object.website)
  end
end
