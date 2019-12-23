module ViewHelper
  def govuk_link_to(body, url = body, html_options = { class: "govuk-link" })
    link_to body, url, html_options
  end

  def govuk_back_link_to(url)
    govuk_link_to("Back", url, class: "govuk-back-link", data: { qa: "page-back" })
  end

  def bat_contact_email_address
    Settings.service_support.contact_email_address
  end

  def bat_contact_mail_to(name = nil, subject: nil, link_class: "govuk-link")
    mail_to bat_contact_email_address, name || bat_contact_email_address, subject: subject, class: link_class
  end
end
