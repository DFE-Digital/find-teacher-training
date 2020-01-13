class ResultsController < ApplicationController
  def index
    query = Course
      .includes(:provider)
      .includes(:accrediting_provider)
      .includes(:financial_incentive)
      .includes(:subjects)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: nil)
      .page(params[:page])
      .per(10)
      .select(courses: %i[
          provider_code
          course_code
          name
          description
          funding_type
          provider
          accrediting_provider
          subjects
        ], providers: %i[
          provider_name
          address1
          address2
          address3
          address4
          postcode
        ])

    query = if params.dig(:sort, :field).nil?
              query.order("provider.provider_name" => "asc")
            else
              query.order(params[:sort][:field] => params[:sort][:order].to_sym)
            end

    @courses = query.all
  end
end
