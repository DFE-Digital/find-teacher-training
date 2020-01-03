describe Provider do
  context "#supporting_dfe_apply?" do
    it "is an opted-in provider" do
      provider = build(:provider, provider_code: "R55")
      expect(provider.supporting_dfe_apply?).to eq(true)
    end

    it "is not an opted-in provider" do
      provider = build(:provider, provider_code: "122")
      expect(provider.supporting_dfe_apply?).to eq(false)
    end
  end
end
