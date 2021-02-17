module ViewHelper
  def govuk_mail_to(email, name = nil, html_options = {}, &block)
    mail_to(email, name, html_options.merge(class: 'govuk-link'), &block)
  end

  def govuk_link_to(body = nil, url = nil, html_options = nil, &block)
    if block_given?
      html_options = url
      url = body
      body = block
    end
    html_options ||= {}

    html_options[:class] = prepend_css_class('govuk-link', html_options[:class])

    return link_to(url, html_options) { yield } if block_given?

    link_to(body, url, html_options)
  end

  def govuk_back_link_to(url, link_text = 'Back')
    link_to link_text, url, class: 'govuk-back-link', data: { qa: 'page-back' }
  end

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
