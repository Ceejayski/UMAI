require 'rails_helper'

RSpec.describe IpsController, type: :controller do
  describe '#index' do
    subject { get :index }
    let(:ip) { create :ip }
    it 'should return success response' do

      subject

      expect(response).to have_http_status(:ok)
    end
  end
end
