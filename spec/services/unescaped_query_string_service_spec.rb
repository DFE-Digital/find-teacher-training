require_relative "../../app/services/unescaped_query_string_service"

RSpec.describe UnescapedQueryStringService do
  subject { described_class.call(base_path: "/test", parameters: { test: "1,2,3" }) }
  it { is_expected.to eq("/test?test=1,2,3") }
end
