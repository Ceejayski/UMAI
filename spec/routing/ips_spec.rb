require 'rails_helper'

RSpec.describe IpsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/ips').to route_to('ips#index')
    end
  end
end
