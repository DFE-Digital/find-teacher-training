require './app/helpers/csharp_rails_subject_conversion_helper'

class CsharpSubjectConversionMiddleware
  include CsharpRailsSubjectConversionHelper

  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    request = Rack::Request.new(env)

    converted_params = convert_csharp_subject_id_params_to_subject_code(request.params['subjects'])

    if request.params['subject_codes'].blank? && converted_params.present?
      request.update_param('subject_codes', converted_params)
      request.delete_param('subjects')
    end

    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
