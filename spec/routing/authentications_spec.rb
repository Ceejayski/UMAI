require 'rails_helper'

describe 'Authentication rotes' do
  it 'should route to access_tokens create action' do
    expect(post '/login').to route_to('authentications#authenticate')
  end
end