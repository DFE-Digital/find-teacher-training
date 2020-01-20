module Filters
  class FundingController < ApplicationController
    def new; end

    def create
      redirect_to results_path(funding: params[:funding])
    end
  end
end
