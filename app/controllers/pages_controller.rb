class PagesController < ApplicationController
  def home; end

  def show
    render template: "pages/#{params[:page]}"
  end
end
