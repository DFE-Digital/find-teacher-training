# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def terms; end

  def privacy; end

  def cookies; end

  def accessibilty; end

  def show
    render template: "pages/#{params[:page]}"
  end
end
