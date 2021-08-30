require 'rails_helper'

shared_examples_for 'unauthorised_request' do
  let(:json) do
    JSON.parse(response.body)
  end
  let :authentication_error do
    {
      'status' => '401',
      'source' => { 'pointer' => '/data/attributes/password' },
      'title' => 'Invalid login or password',
      'detail' => 'You must provide valid credentials in order to exchange them for token.',
      'user_authentication' => 'invalid credentials'
    }
  end
  it 'should return 401 status code' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    expect(json['errors']['user_authentication']).to include(authentication_error['user_authentication'])
  end
end

shared_examples_for 'forbidden_requests' do
  let(:authorization_error) do
    'Unauthorized'
  end

  it 'should return 403 status code' do
    subject
    expect(response).to have_http_status(403)
  end

  it 'should return proper error json' do
    subject
    json = JSON.parse(response.body)
    pp json
    expect(json['error']).to include(authorization_error)
  end
end

shared_examples_for 'unprocessable_details' do
  let(:json) do
    JSON.parse(response.body)
  end
  let :error do
    [{ 'code' => 'blank', 'detail' => "Content can't be blank", 'source' => { 'pointer' => '/data/attributes/content' },
       'status' => '422', 'title' => 'Unprocessable Entity' }]
  end

  it 'should return proper error body' do
    subject
    expect(json['errors']).to eql(error)
  end
end
