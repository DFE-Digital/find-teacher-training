module ResultFilters
  class StudyTypeController < ApplicationController
    include FilterParameters

    def new; end

    def create
      if [filter_params[:fulltime], filter_params[:parttime]].any? { |param| param.downcase == "true" }
        redirect_to results_path(filter_params)
      else
        flash[:error] = "You must make at least one selection"
        redirect_to studytype_path(filter_params)
      end
    end
  end
end
