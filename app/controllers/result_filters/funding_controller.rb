module ResultFilters
  class FundingController < ApplicationController
    include FilterParameters
    def new; end

    def create
      redirect_to results_path(filter_params)
    end
  end
end
