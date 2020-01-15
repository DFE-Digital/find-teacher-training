require "rails_helper"

feature "ResultFilters::SubjectHelper", type: :helper do
  describe "#subject_is_selected?" do
    it "indicates that the subject is selected" do
      controller.params[:subjects] = "1,2,3"
      expect(helper.subject_is_selected?(id: "2")).to eq(true)
    end

    it "indicates that the subject is not selected" do
      controller.params[:subjects] = "1,2,3"
      expect(helper.subject_is_selected?(id: "4")).to eq(false)
    end
  end
end
