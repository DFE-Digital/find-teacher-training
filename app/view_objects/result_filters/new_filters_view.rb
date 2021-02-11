module ResultFilters
  class NewFiltersView
    def initialize(params:)
      @params = params
    end

    def qts_only_checked?
      checked?('QtsOnly')
    end

    def pgde_pgce_with_qts_checked?
      checked?('PgdePgceWithQts')
    end

    def other_checked?
      checked?('Other')
    end

    def qualification_selected?
      return false if params[:qualifications].nil?

      params[:qualifications].any?
    end

    def qualification_params_nil?
      params[:qualifications].nil?
    end

    def location_query?
      params[:l] == '1'
    end

    def across_england_query?
      params[:l] == '2'
    end

    def provider_query?
      params[:l] == '3'
    end

    def funding_checked?
      params[:funding] == '8'
    end

    def send_checked?
      params[:senCourses] == 'true'
    end

    def has_vacancies_checked?
      params[:hasvacancies] == 'true'
    end

    def full_time_checked?
      params[:fulltime] == 'true'
    end

    def part_time_checked?
      params[:parttime] == 'true'
    end

    def default_to_true
      params[:fulltime] != 'true' && params[:parttime] != 'true'
    end

  private

    attr_reader :params

    def checked?(param_value)
      return false if params[:qualifications].nil?

      param_value.in?(params[:qualifications])
    end
  end
end
