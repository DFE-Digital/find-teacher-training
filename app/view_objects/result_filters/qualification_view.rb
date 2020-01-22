module ResultFilters
  class QualificationView
    def initialize(params:)
      @qualifications_parameter = params[:qualifications]
    end

    def qts_only_checked?
      checked?("QtsOnly")
    end

    def pgde_pgce_with_qts_checked?
      checked?("PgdePgceWithQts")
    end

    def other_checked?
      checked?("Other")
    end

    def qualification_selected?
      parameter_array.any?
    end

  private

    attr_reader :qualifications_parameter

    def parameter_array
      qualifications_parameter.present? ? qualifications_parameter.split(",") : []
    end

    def checked?(param_value)
      parameter_array.empty? || parameter_array.include?(param_value)
    end
  end
end
