require 'rails_helper'

RSpec.describe 'results/try_another_search_text.html.erb', type: :view do
  let(:html) { render partial: 'results/try_another_search_text.html.erb' }
  let(:salary_suffix) { 'or searching for courses that do not offer a salary' }

  before do
    assign(:results_view, instance_double(ResultsView, with_salaries?: with_salaries))
  end

  context 'with_salaries is true' do
    let(:with_salaries) { true }

    it 'renders the salary suffix ' do
      expect(html).to match(salary_suffix)
    end
  end

  context 'with_salaries is false' do
    let(:with_salaries) { false }

    it "doesn't render the salary suffix " do
      expect(html).not_to match(salary_suffix)
    end
  end
end
