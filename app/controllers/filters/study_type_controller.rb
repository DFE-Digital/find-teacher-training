module Filters
  class StudyTypeController < ApplicationController
    include FilterParameters

    def new; end

    def create
      if !(filter_params[:fulltime] == "True" || filter_params[:parttime] == "True")
        flash[:error] = "You must make at least one selection"
        redirect_to studytype_path(filter_params)
      else
        redirect_to results_path(filter_params)
      end
    end
  end
end
