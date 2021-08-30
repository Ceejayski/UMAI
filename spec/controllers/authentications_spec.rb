require 'rails_helper'
require 'json'

RSpec.describe AuthenticationsController, type: :controller do
  describe 'Authenticate' do
    let(:user) do
      User.create(login: 'jsmith', password: 'secret', password_confirmation: 'secret')
    end
    let(:json) do
      JSON.parse(response.body)
    end

    context 'when no params_data is provided' do
      subject { post :authenticate }
      it_behaves_like 'unauthorised_request'
    end

    it 'when login is wrong the user login' do
      post :authenticate, params: { login: 'invalid', password: user.password }
      expect(response).to have_http_status(401)
      expect(json['errors']['user_authentication']).to include('invalid credentials')
    end

    it 'when user password is wrong' do
      post :authenticate, params: { login: user.login, password: 'none' }
      expect(response).to have_http_status(401)
      expect(json['errors']['user_authentication']).to include('invalid credentials')
    end

    it 'Succesfully authenticate user' do
      post :authenticate, params: { login: user.login, password: user.password }
      expect(response).to have_http_status(200)

      expect(json).to have_key('auth_token')
    end
  end
end
