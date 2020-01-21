module FilterParameters
private

  def filter_params
    request.request_parameters.reject { |param| param == "utf8" }
  end
end
