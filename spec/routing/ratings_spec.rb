require 'rails_helper'

RSpec.describe RatingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'posts/1/ratings').to route_to('ratings#index', post_id: '1')
    end

    it 'routes to #create' do
      expect(post: 'posts/1/ratings').to route_to('ratings#create', post_id: '1')
    end
  end
end
