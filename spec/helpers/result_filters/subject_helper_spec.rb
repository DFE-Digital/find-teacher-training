require 'rails_helper'

describe 'ResultFilters::SubjectHelper' do
  describe '#subject_is_selected?' do
    it 'indicates that the subject is selected' do
      controller.params[:subject_codes] = '00,01,02'
      expect(helper.subject_is_selected?(subject_code: '02')).to be(true)
    end

    it 'indicates that the subject is not selected' do
      controller.params[:subjects] = '00,01,02'
      expect(helper.subject_is_selected?(subject_code: '04')).to be(false)
    end
  end

  describe '#no_subject_selected_error?' do
    it 'returns true if no subject is selected' do
      allow(controller).to receive(:flash).and_return(error: I18n.t('subject_filter.errors.no_option'))

      expect(helper.no_subject_selected_error?).to be(true)
    end

    it 'returns false if there is no subject selected' do
      expect(helper.no_subject_selected_error?).to be(false)
    end
  end
end
