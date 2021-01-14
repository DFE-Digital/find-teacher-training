require 'rails_helper'

RSpec.describe 'shared/hidden_previous_fields.html.erb', type: :view do
  let(:form_builder) { double }

  before do
    allow(form_builder).to receive(:hidden_field)
    render partial: 'shared/hidden_previous_fields', locals: { form: form_builder, params: params }
  end

  context 'prev_ parameters are present in the params' do
    let(:params) { { 'prev_l' => 'test-prev' } }

    it 'uses the previous value' do
      expect(form_builder).to have_received(:hidden_field).with('prev_l', value: 'test-prev')
    end
  end

  context 'prev_ parameters are not present in the params' do
    let(:params) { { 'loc' => 'test-prev' } }

    it 'uses the current value' do
      expect(form_builder).to have_received(:hidden_field).with('prev_loc', value: 'test-prev')
    end
  end

  context 'neither prev_ nor current parameters present in the params' do
    let(:params) { {} }

    it "uses 'none'" do
      expect(form_builder).to have_received(:hidden_field).with('prev_loc', value: 'none')
    end
  end
end
