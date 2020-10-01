require "rails_helper"

RSpec.describe Base do
  describe "connection_class" do
    before do
      RequestStore.store[:request_id] = "some-request-id"
    end

    it "connection sends X-Request-Id header" do
      stub = stub_request(:post, "#{Settings.teacher_training_api.base_url}/api/v3/bases")
        .with(
          body: "{\"data\":{\"type\":\"bases\",\"attributes\":{}}}",
          headers: {
            "X-Request-Id" => "some-request-id",
          },
        ).to_return(status: 200, body: "", headers: {})

      Base.new.save

      expect(stub).to have_been_requested
    end
  end
end
