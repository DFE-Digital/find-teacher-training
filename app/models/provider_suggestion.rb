class ProviderSuggestion < Base
  def self.suggest(query)
    self.requestor.__send__(
      :request, :get, "/api/v3/provider-suggestions?query=#{query}"
    )
  end
end
