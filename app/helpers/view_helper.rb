module ViewHelper
  def environment_colour
    case Rails.env
    when 'development'
      'grey'
    when 'sandbox'
      'purple'
    end
  end

  def environment_label
    case Rails.env
    when 'development'
      'Development'
    when 'sandbox'
      'Sandbox'
    when 'production'
      'Beta'
    end
  end

  def environment_header_class
    "app-header--#{Rails.env}"
  end

  def permitted_referrer?
    return false if request.referer.blank?

    request.referer.include?(request.host_with_port) ||
      Settings.valid_referers.any? { |url| request.referer.start_with?(url) }
  end

  def bat_contact_email_address
    Settings.service_support.contact_email_address
  end

  def bat_contact_email_address_with_wrap
    # https://developer.mozilla.org/en-US/docs/Web/HTML/Element/wbr
    # The <wbr> element will not be copied when copying and pasting the email address
    bat_contact_email_address.gsub('@', '<wbr>@').html_safe
  end

  def bat_contact_mail_to(name = nil, **kwargs)
    govuk_mail_to bat_contact_email_address, name || bat_contact_email_address_with_wrap, **kwargs
  end

  def title_with_error_prefix(title, error)
    "#{t('page_titles.error_prefix') if error}#{title}"
  end

  def visa_sponsorship_status(provider)
    if provider.can_sponsor_all_visas?
      'can sponsor Student and Skilled Worker visas, but this is not guaranteed'
    elsif provider.can_only_sponsor_student_visa?
      'can sponsor Student visas, but this is not guaranteed'
    elsif provider.can_only_sponsor_skilled_worker_visa?
      'can sponsor Skilled Worker visas, but this is not guaranteed'
    else
      'cannot sponsor visas'
    end
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
