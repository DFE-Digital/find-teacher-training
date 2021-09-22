require 'rails_helper'

describe MaintenanceBannerComponent, type: :component do
  context 'when the `maintenance_mode` flag is active' do
    it 'renders the correct content' do
      activate_feature(:maintenance_banner)
      result = render_inline(described_class.new)

      expect(result.text).to have_content 'This service will be unavailable on'
    end
  end

  context 'when the `maintenance_mode` flag is deactive' do
    it 'does not render' do
      deactivate_feature(:maintenance_banner)

      result = render_inline(described_class.new)

      expect(result.text).to be_blank
    end
  end
end
