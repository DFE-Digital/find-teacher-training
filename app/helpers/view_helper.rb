module ViewHelper
  def govuk_link_to(body, url = body, html_options = { class: "govuk-link" })
    link_to body, url, html_options
  end

  def govuk_back_link_to(url, link_text = "Back")
    govuk_link_to(link_text, url, class: "govuk-back-link", data: { qa: "page-back" })
  end

  def permitted_referrer?
    return false if request.referer.blank?

    request.referer.start_with?(Settings.search_and_compare_ui.base_url) ||
      request.referer.start_with?(request.host_with_port)
  end

  def bat_contact_email_address
    Settings.service_support.contact_email_address
  end

  def bat_contact_mail_to(name = nil, subject: nil, link_class: "govuk-link")
    mail_to bat_contact_email_address, name || bat_contact_email_address, subject: subject, class: link_class
  end
end
