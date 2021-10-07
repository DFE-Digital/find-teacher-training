class DeprecatedParametersService
  def initialize(parameters:)
    @original_parameters = parameters
    @search_parameter_service = NormaliseSearchParametersService.new.call(parameters: params_hash)
  end

  def deprecated?
    search_parameter_service[:deprecated] || legacy_params_values?
  end

  def parameters
    if deprecated?
      search_parameter_service[:parameters]
    else
      params_hash
    end
  end

private

  def legacy_params_values?
    @legacy_params_values ||= original_parameters.key?('rad') && original_parameters['rad'] != ResultsView::MILES
  end

  def params_hash
    if legacy_params_values?
      original_parameters['rad'] = ResultsView::MILES

      if original_parameters.key? 'page'
        original_parameters['page'] = 1
      end
    end
    original_parameters
  end

  attr_reader :original_parameters, :search_parameter_service
end
