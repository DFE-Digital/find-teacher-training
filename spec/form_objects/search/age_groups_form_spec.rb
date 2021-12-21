require 'rails_helper'

module Search
  describe AgeGroupsForm do
    describe 'validation' do
      it 'is not valid when no option is selected' do
        form = Search::AgeGroupsForm.new

        expect(form.valid?).to be(false)
      end

      it 'is not valid when selected option is not one of the accepted age groups' do
        form = Search::AgeGroupsForm.new(age_group: 'foo')

        expect(form.valid?).to be(false)
      end

      %w[primary secondary further_education].each do |age_group|
        it "is valid when option selected is #{age_group}" do
          form = Search::AgeGroupsForm.new(age_group: age_group)

          expect(form.valid?).to be(true)
        end
      end
    end
  end
end
