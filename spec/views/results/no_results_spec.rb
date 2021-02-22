require 'rails_helper'

describe 'results/no_results.html.erb', type: :view do
  context 'Scotland' do
    let(:html) do
      render partial: 'results/no_results', locals: { country: 'Scotland', devolved_nation: true }
    end

    it 'renders Scottish teacher training website' do
      expect(html).to match('This service is for courses in England')
      expect(html).to have_link('Learn more about teacher training in Scotland', href: 'https://teachinscotland.scot/')
    end
  end

  context 'Wales' do
    let(:html) do
      render partial: 'results/no_results', locals: { country: 'Wales', devolved_nation: true }
    end

    it 'renders Welsh teacher training website' do
      expect(html).to match('This service is for courses in England')
      expect(html).to have_link('Learn more about teacher training in Wales',
                                href: 'https://www.discoverteaching.wales/routes-into-teaching/')
    end
  end

  context 'Northern Ireland' do
    let(:html) do
      render partial: 'results/no_results', locals: { country: 'Northern Ireland', devolved_nation: true }
    end

    it 'renders Northern Irish teacher training website' do
      expect(html).to match('This service is for courses in England')
      expect(html).to have_link('Learn more about teacher training in Northern Ireland',
                                href: 'https://www.education-ni.gov.uk/articles/initial-teacher-education-courses-northern-ireland')
    end
  end

  context 'England' do
    let(:html) { render partial: 'results/no_results', locals: { country: 'England', devolved_nation: false } }

    it 'renders try another search text' do
      assign(:results_view, ResultsView.new(query_parameters: { 'c' => 'England', 'lat' => '51.4975', 'lng' => '0.1357' }))
      expect(html).to have_link('try another search', href: '/')
    end
  end
end
