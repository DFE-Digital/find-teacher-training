module ResultFilters
  class FiltersView
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

    def visa_checked?
      params[:can_sponsor_visa] == 'true'
    end

    def engineers_teach_physics_checked?
      params[:engineers_teach_physics] == 'true'
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

    def default_study_types_to_true
      params[:fulltime] != 'true' && params[:parttime] != 'true'
    end

    def default_with_vacancies_to_true
      params[:hasvacancies].nil?
    end

    def all_courses_radio_chosen?
      params[:degree_required] == 'show_all_courses'
    end

    def default_all_courses_radio_to_true
      params[:degree_required].nil?
    end

    def two_two_radio_chosen?
      params[:degree_required] == 'two_two'
    end

    def third_class_radio_chosen?
      params[:degree_required] == 'third_class'
    end

    def any_degree_grade_radio_chosen?
      params[:degree_required] == 'not_required'
    end

    def location_query_params
      {
        c: params[:c],
        l: params[:l],
        lq: params[:lq],
        lat: params[:lat],
        loc: params[:loc],
        lng: params[:lng],
        query: params[:query],
        rad: params[:rad],
        sortby: params[:sortby],
      }
    end

  private

    attr_reader :params

    def checked?(param_value)
      return false if params[:qualifications].nil?

      param_value.in?(params[:qualifications])
    end
  end
end
