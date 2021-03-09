require 'rails_helper'

RSpec.feature 'Results page new subject filter' do
  include StubbedRequests::Courses
  include StubbedRequests::SubjectAreas
  include StubbedRequests::Subjects

  let(:filter_page) { PageObjects::Page::ResultFilters::SubjectPage.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_courses(query: base_parameters, course_count: 10)
    stub_subject_areas
    stub_subjects
  end

  describe 'applying a filter' do
    before do
      stub_courses(query: base_parameters, course_count: 10)
    end

    context 'with subjects selected' do
      before do
        stub_courses(
          query: base_parameters.merge('filter[subjects]' => '00,01,F1,Q8,P3'),
          course_count: 10,
        )

        results_page.load
        results_page.subjects_filter.link.click
        filter_page.subject_areas.first.subjects[0].checkbox.click
        filter_page.subject_areas.first.subjects[1].checkbox.click
        filter_page.subject_areas.second.subjects[3].checkbox.click
        filter_page.subject_areas.second.subjects[5].checkbox.click
        filter_page.subject_areas.second.subjects[6].checkbox.click
        filter_page.continue.click
      end

      it 'lists the results' do
        expect(results_page.heading.text).to eq('Teacher training courses 10 courses found')
        expect(results_page.subjects_filter.subjects.first.text).to eq(
          'Chemistry, Classics, Communication and media studies, Primary, Primary with English',
        )
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'false',
            'parttime' => 'false',
            'hasvacancies' => 'true',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
            'subjects' => %w[31 32 3 5 47],
          },
        )
      end
    end
  end

  context 'with only SEND courses selected' do
    before do
      query = base_parameters.merge(
        'filter[subjects]' => '00,01,F1',
        'filter[send_courses]' => 'true',
      )
      stub_courses(query: query, course_count: 10)

      results_page.load
      results_page.subjects_filter.link.click
      filter_page.subject_areas.first.subjects[0].checkbox.click
      filter_page.subject_areas.first.subjects[1].checkbox.click
      filter_page.subject_areas.second.subjects[3].checkbox.click
      filter_page.send_area.subjects.first.checkbox.click
      filter_page.continue.click
    end

    it 'lists the results' do
      expect(results_page.heading.text).to eq('Teacher training courses 10 courses found')
      expect(results_page.subjects_filter.subjects.map.first.text).to eq('Chemistry, Primary, Primary with English')
      expect(results_page.send_filter.checkbox.checked?).to be(true)
    end

    it 'retains the query parameters' do
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          'fulltime' => 'false',
          'parttime' => 'false',
          'hasvacancies' => 'true',
          'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          'subjects' => %w[31 32 3],
          'senCourses' => 'true',
        },
      )
    end
  end

  describe 'subject filter page' do
    before do
      filter_page.load
    end

    it "displays 'Back to search results' for the back link" do
      expect(filter_page.back_link.text).to eq('Back to search results')
    end

    it "displays 'Find courses' for the continue" do
      expect(filter_page.continue.value).to eq('Find courses')
    end
  end

  describe 'Validation' do
    context 'no subject selected' do
      before do
        filter_page.load
        filter_page.continue.click
      end

      it 'displays an error' do
        expect(filter_page).to have_error
      end

      it 'expands the first accordion and sets assistive technology attributes appropriately' do
        expect(filter_page.subject_areas.first.root_element).to match_selector('.govuk-accordion__section--expanded')
        expect(filter_page.subject_areas.first.accordion_button).to match_selector('[aria-expanded="true"]')

        expect(filter_page.subject_areas.second.root_element).not_to match_selector('.govuk-accordion__section--expanded')
        expect(filter_page.subject_areas.second.accordion_button).not_to match_selector('[aria-expanded="true"]')
      end

      it 'stays on the subject filter page' do
        expect(filter_page.back_link.text).to eq('Back to search results')
        expect(page).to have_current_path(subject_path, ignore_query: true)
        expect(filter_page.continue.value).to eq('Find courses')
      end
    end
  end

  describe 'back link' do
    it 'navigates back to the results page' do
      filter_page.load(query: { test: 'params' })
      filter_page.back_link.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          'fulltime' => 'false',
          'hasvacancies' => 'true',
          'parttime' => 'false',
          'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          'senCourses' => 'false',
          'test' => 'params',
        },
      )
    end
  end

  context 'check each accordion section' do
    before { filter_page.load }

    it 'has aria-control set to the section-content id' do
      expected_control_ids = %w[
        primary-content
        secondary-content
        secondary-modern-languages-content
        further-education-content
      ]

      filter_page.subject_areas.each_with_index do |accordion_section, counter|
        expect(accordion_section.root_element).to have_selector("##{expected_control_ids[counter]}")
      end

      # Check SEND section
      expect(filter_page.send_area.root_element).to have_selector('div#send-content')
    end

    it 'has a fieldset and legend for each subject area' do
      expect(filter_page.subject_areas.map(&:legend).map(&:text)).to eq(
        [
          'Choose from the following Primary subjects',
          'Choose from the following Secondary subjects',
          'Choose from the following Secondary: Modern languages subjects',
          'Choose from the following Further education subjects',
        ],
      )
    end
  end

  context 'on the start page' do
    it 'has a back link to the root page' do
      visit start_subject_path
      filter_page.back_link.click
      expect(URI(current_url).path).to eq('/')
    end

    it "the submit button displays 'Continue'" do
      visit start_subject_path
      expect(filter_page.continue.value).to eq('Continue')
    end
  end

  context 'with no selected subjects' do
    before { filter_page.load }

    let(:expected_financial_info) do
      [
        'Scholarships of £2,000 are available.',
        'Bursaries of £1,000 available.',
        'Scholarships of £4,000 and bursaries of £3,000 are available, with early career payments of £2,000 each in your second, third and fourth year of teaching (£3,000 in some areas of England).',
        '',
      ]
    end

    it 'sets assistive technology attributes appropriately' do
      expect(filter_page.subject_areas.first.accordion_button).to match_selector('[aria-expanded="false"]')
      expect(filter_page.send_area.accordion_button).to match_selector('[aria-expanded="false"]')
    end

    it 'does not expand any accordion sections' do
      expect(filter_page.subject_areas.first.root_element).to have_no_css('.govuk-accordion__section--expanded')
      expect(filter_page.send_area.root_element).to have_no_css('.govuk-accordion__section--expanded')
    end

    it 'displays all subject areas' do
      expect(filter_page.subject_areas.map(&:name).map(&:text)).to eq(
        [
          'Primary',
          'Secondary',
          'Secondary: Modern languages',
          'Further education',
        ],
      )
    end

    it 'displays financial information' do
      subjects = filter_page.subject_areas.first.subjects
      expect(subjects.fourth.info.text).to eq('Bursaries of £6,000 available.')
      expect(subjects.fourth.ske_course.text).to eq('You can also take a subject knowledge enhancement (SKE) course.')
    end
  end

  context 'with previously selected subjects' do
    it 'automatically selects the given checkboxes' do
      visit subject_path(subjects: %w[31], senCourses: 'true')
      expect(filter_page.subject_areas.first.subjects.first.checkbox).to be_checked
      expect(filter_page.send_area.subjects.first.checkbox).to be_checked
    end

    it 'automatically selects the given checkboxes with C# casing' do
      filter_page.load(query: { senCourses: 'True' })
      expect(filter_page.send_area.subjects.first.checkbox).to be_checked
    end

    it 'lets you unselect SEND and other subjects' do
      stub_courses(
        query: base_parameters.merge('filter[subjects]' => '01'),
        course_count: 10,
      )

      visit subject_path(subjects: %w[31], senCourses: 'true')
      filter_page.subject_areas.first.subjects[0].checkbox.click
      filter_page.subject_areas.first.subjects[1].checkbox.click
      filter_page.send_area.subjects.first.checkbox.click
      filter_page.continue.click

      expect(results_page.subjects_filter.subjects.map(&:text))
        .to eq(
          [
            'Primary with English',
          ],
        )
    end
  end

  context 'with existing parameters' do
    before do
      stub_courses(
        query: base_parameters.merge('filter[subjects]' => '00,01'),
        course_count: 10,
      )
    end

    it 'only changes the subjects params' do
      visit subject_path(subjects: %w[32 31], other_param: 'param_value')
      filter_page.continue.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          'subjects' => %w[31 32],
          'other_param' => 'param_value',
        },
      )
    end
  end

  context 'with the modern languages subject' do
    before do
      filter_page.load
    end

    it 'excludes the modern languages subject' do
      secondary_modern_languages = filter_page.subject_areas.third
      expect(secondary_modern_languages.subjects.map(&:text)).not_to include('Modern languages')
    end
  end

  context 'with the design and technology subject' do
    it 'displays additional content' do
      filter_page.load
      secondary_area = filter_page.subject_areas.second
      dt_subject = secondary_area.subjects[9]
      expect(dt_subject.name.text).to eq('Design and technology – also includes food, product design, textiles, and systems and control')
    end
  end
end
