module Filters
  class VacancyController < ApplicationController
    def new; end

    def create
      redirect_to results_path(filter_params)
    end

  private

    def filter_params
      params.permit(:hasvacancies)
    end
  end
end
