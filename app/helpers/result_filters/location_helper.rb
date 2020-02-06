module ResultFilters
  module LocationHelper
    def provider_error?
      flash[:error] && flash[:error].include?(I18n.t("location_filter.fields.provider"))
    end

    def location_error?
      flash[:error] && flash[:error].include?(I18n.t("location_filter.fields.location"))
    end

    def no_option_selected?
      flash[:error] && flash[:error].include?(I18n.t("location_filter.errors.no_option"))
    end
  end
end
