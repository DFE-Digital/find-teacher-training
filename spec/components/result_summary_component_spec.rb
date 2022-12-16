require 'rails_helper'

describe ResultSummaryComponent, type: :component do
  context 'when no courses are found' do
    it 'renders the correct summary when location is used' do
      results = instance_double(ResultsView, location_filter?: true, england_filter?: false, provider_filter?: false)

      allow(results).to receive(:location_search).and_return('Brighton')
      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(0)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('No art and design courses found in Brighton')
    end

    it 'renders the correct summary when england is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: true, provider_filter?: false)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(0)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('No art and design courses found in England')
    end

    it 'renders the correct summary when provider is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: false, provider_filter?: true)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:provider).and_return('University of Brighton')
      allow(results).to receive(:course_count).and_return(0)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('No art and design courses found from University of Brighton')
    end
  end

  context 'when one course is found' do
    it 'renders the correct summary when location is used' do
      results = instance_double(ResultsView, location_filter?: true, england_filter?: false, provider_filter?: false)

      allow(results).to receive(:location_search).and_return('Brighton')
      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(1)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('1 art and design course in Brighton')
    end

    it 'renders the correct summary when england is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: true, provider_filter?: false)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(1)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('1 art and design course in England')
    end

    it 'renders the correct summary when provider is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: false, provider_filter?: true)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:provider).and_return('University of Brighton')
      allow(results).to receive(:course_count).and_return(1)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('1 art and design course from University of Brighton')
    end
  end

  context 'when multiple courses are found' do
    it 'renders the correct summary when location is used' do
      results = instance_double(ResultsView, location_filter?: true, england_filter?: false, provider_filter?: false)

      allow(results).to receive(:location_search).and_return('Brighton')
      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(2)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('2 art and design courses in Brighton')
    end

    it 'renders the correct summary when england is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: true, provider_filter?: false)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:course_count).and_return(2)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('2 art and design courses in England')
    end

    it 'renders the correct summary when provider is used' do
      results = instance_double(ResultsView, location_filter?: false, england_filter?: false, provider_filter?: true)

      allow(results).to receive(:subjects).and_return([{ subject_name: 'Art and design' }])
      allow(results).to receive(:provider).and_return('University of Brighton')
      allow(results).to receive(:course_count).and_return(2)

      page = render_inline(described_class.new(results:))

      expect(page.text).to include('2 art and design courses from University of Brighton')
    end
  end
end
