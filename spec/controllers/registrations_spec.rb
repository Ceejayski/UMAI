require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe '#create' do
    let(:json) { response }
    subject { post :create, params: params }
    context 'when invalid data provided' do
      let(:params) do
        {
          data: {
            attributes: {
              login: nil,
              password: nil,
              password_confirmation: nil
            }
          }
        }
      end
      it 'should return unprocessable_entity status code' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not create a user' do
        expect { subject }.not_to change { User.count }
      end

      it 'should return error messages in response body' do
        subject
      end
    end
  end
  context 'when valid data provided' do
    let(:params) do
      {
        data: {
          attributes: {
            login: 'jsmith45',
            password: 'secretpassword',
            password_confirmation: 'secretpassword'

          }
        }
      }
    end

    it 'should return 201 http status code' do
      post :create, params: params
      expect(response).to have_http_status(201)
    end

  end
end
