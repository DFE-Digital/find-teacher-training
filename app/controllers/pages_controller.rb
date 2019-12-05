# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def terms; end

  def privacy; end

  def cookies; end

  def accessibilty; end

  def show
    render template: "pages/#{page_param}"
  end

  def page_param
    params.require(:page)
  end
end
