module ViewHelper
  def permitted_referrer?
    return false if request.referer.blank?

    request.referer.include?(request.host_with_port) ||
      Settings.valid_referers.any? { |url| request.referer.start_with?(url) }
  end

  def bat_contact_email_address
    Settings.service_support.contact_email_address
  end

  def bat_contact_mail_to(name = nil, subject: nil, link_class: 'govuk-link')
    mail_to bat_contact_email_address, name || bat_contact_email_address, subject: subject, class: link_class
  end

  def title_with_error_prefix(title, error)
    "#{t('page_titles.error_prefix') if error}#{title}"
  end

private

  def prepend_css_class(css_class, current_class)
    if current_class
      current_class.prepend("#{css_class} ")
    else
      css_class
    end
  end
end
