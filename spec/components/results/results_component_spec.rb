require 'rails_helper'

describe Results::ResultsComponent, type: :component do
  include StubbedRequests::Courses

  before do
    allow(LocationSubjectFilterComponent).to receive(:new).and_return(plain: '')
    allow(Results::FilterComponent).to receive(:new).and_return(plain: '')
    allow(Results::SortByComponent).to receive(:new).and_return(plain: '')
    allow(Results::SearchResultComponent).to receive(:new).and_return(plain: '')
  end

  context 'when there are no search results' do
    before do
      stub_courses(query: {}, course_count: 0)
    end

    let(:results_view) do
      instance_double(
        ResultsView,
        country: 'Scotland',
        devolved_nation?: true,
        subjects: [],
        total_pages: 0,
        number_of_courses_string: 'No courses',
        no_results_found?: true,
        suggested_search_visible?: false,
        has_results?: false,
      )
    end
    let(:courses) { Course.where(recruitment_cycle_year: RecruitmentCycle.current_year).all }

    it 'renders a "No courses found" message when there are no results' do
      stub_courses(query: {}, course_count: 0)
      courses = Course.where(recruitment_cycle_year: RecruitmentCycle.current_year).all
      component = render_inline(
        described_class.new(results: results_view, courses:),
      )

      expect(component.text).to include('No courses found')
    end

    it 'renders the inset text' do
      stub_courses(query: {}, course_count: 0)
      courses = Course.where(recruitment_cycle_year: RecruitmentCycle.current_year).all
      component = render_inline(
        described_class.new(results: results_view, courses:),
      )
      expect(component.text).to include('event near you')
    end
  end

  context 'when there are 10 matching courses' do
    before do
      stub_courses(query: {}, course_count: 10)
    end

    let(:results_view) do
      instance_double(
        ResultsView,
        country: 'England',
        devolved_nation?: false,
        subjects: [],
        total_pages: 1,
        number_of_courses_string: '10 courses',
        no_results_found?: false,
        suggested_search_visible?: false,
        has_results?: true,
        has_sites?: true,
        location_filter?: false,
      )
    end
    let(:courses) do
      Course.where(recruitment_cycle_year: RecruitmentCycle.current_year).all
    end

    it 'renders "10 courses found" and a `SearchResultComponent` for each course' do
      allow(Results::SearchResultComponent).to receive(:new).and_return(plain: '')

      component = render_inline(
        described_class.new(results: results_view, courses:),
      )

      courses.each do |course|
        expect(Results::SearchResultComponent).to have_received(:new).with(
          course:,
          has_sites: true,
          filtered_by_location: false,
        )
      end

      expect(component.text).to include('10 courses found')
    end

    it 'renders the inset text' do
      component = render_inline(
        described_class.new(results: results_view, courses:),
      )

      courses.each do |course|
        expect(Results::SearchResultComponent).to have_received(:new).with(
          course:,
          has_sites: true,
          filtered_by_location: false,
        )
      end
      expect(component.text).to include('event near you')
    end
  end
end
