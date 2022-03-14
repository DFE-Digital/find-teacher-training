require 'rails_helper'

describe 'ResultFilters::LocationHelper', type: :helper do
  describe '#provider_error?' do
    it 'returns true if provider error is displayed' do
      allow(controller).to receive(:flash).and_return(error: I18n.t('location_filter.fields.provider'))

      expect(helper.provider_error?).to be(true)
    end

    it 'returns false if no error is displayed' do
      expect(helper.provider_error?).to be(false)
    end
  end

  describe '#location_error?' do
    it 'returns true if location error is displayed' do
      allow(controller).to receive(:flash).and_return(error: I18n.t('location_filter.fields.location'))

      expect(helper.location_error?).to be(true)
    end

    it 'returns false if no error is displayed' do
      expect(helper.location_error?).to be(false)
    end
  end

  describe '#no_option_selected?' do
    it 'returns true if no option selected error is displayed' do
      allow(controller).to receive(:flash).and_return(error: I18n.t('location_filter.errors.no_option'))

      expect(helper.no_option_selected?).to be(true)
    end

    it 'returns false if no error is displayed' do
      expect(helper.no_option_selected?).to be(false)
    end
  end
end
