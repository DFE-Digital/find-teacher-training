module ResultFilters
  class VacancyController < ApplicationController
    include FilterParameters

    def new; end

    def create
      redirect_to results_path(filter_params)
    end
  end
end
