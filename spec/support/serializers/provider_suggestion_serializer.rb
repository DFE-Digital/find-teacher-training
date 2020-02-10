class ProviderSuggestionSerializer < JSONAPI::Serializable::Resource
  type "provider_suggestion"

  attributes(*FactoryBot.attributes_for("provider_suggestion").keys)
end
