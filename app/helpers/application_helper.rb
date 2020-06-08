# frozen_string_literal: true

module ApplicationHelper
  def markdown(source)
    render = Govuk::MarkdownRenderer
    # Options: https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
    # lax_spacing: HTML blocks do not require to be surrounded by an empty line as in the Markdown standard.
    # autolink: parse links even when they are not enclosed in <> characters
    options = { autolink: true, lax_spacing: true }
    markdown = Redcarpet::Markdown.new(render, options)
    source_with_smart_quotes = RubyPants.new(source).to_html
    markdown.render(source_with_smart_quotes).html_safe
  end

  def smart_quotes(string)
    RubyPants.new(string).to_html.html_safe
  end
end
