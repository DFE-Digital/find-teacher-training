
class DeprecatedParametersService
  def initialize(parameters:)
    @parameters = parameters
  end

  class << self
    def call(**args)
      new(args).call
    end
  end

  def call
    csharp_parameter_converter = ConvertDeprecatedCsharpParametersService.new.call(parameters: params_hash)
    { deprecated: csharp_parameter_converter[:deprecated] || have_legacy_params_values, parameters: csharp_parameter_converter[:parameters] }
  end

  private_class_method :new

private
  

  def have_legacy_params_values
    @have_legacy_params_values ||= parameters.has_key?("rad") && parameters["rad"] != ResultsView::MILES
  end

  def params_hash
    if have_legacy_params_values
      parameters["rad"] = ResultsView::MILES

      if parameters.has_key? "page"
        parameters["page"] = 1
      end
    end
    parameters
  end

  attr_reader :base_path, :parameters
end

