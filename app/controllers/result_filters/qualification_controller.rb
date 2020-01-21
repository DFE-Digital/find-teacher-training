module ResultFilters
  class QualificationController < ApplicationController
    include FilterParameters

    before_action :create_view

    def new; end

    def create
      if @view.qualification_selected?
        redirect_to results_path(filter_params)
      else
        flash[:error] = "Please choose at least one qualification"
        redirect_to qualification_path(filter_params.merge(qualifications: "none"))
      end
    end

  private

    def create_view
      @view = ResultFilters::QualificationView.new(params: params)
    end
  end
end
