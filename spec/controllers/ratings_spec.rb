require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:post1) { create :post }
  let(:json_data){ JSON.parse(response.body)['data']}

  describe "GET #index" do
    subject { get :index, params: { post_id: post1.id } }

    it "returns a success response" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return only ratings belonging to post' do
      rating = create :rating, post: post1
      create :rating
      subject
      expect(json_data.length).to eq(1)
      
      expect(json_data.first['id'].to_i).to eq(rating.id)
    end

    it 'should paginate results' do
      ratings = create_list :rating, 3, post: post1
      get :index, params: { post_id: post1.id, per_page: 1, page: 2 }
      expect(json_data.length).to eq(1)
      rating = ratings.second
      expect(json_data.first['id'].to_i).to eq(rating.id)
    end

    it 'should have proper json body' do
      rating = create :rating, post: post1
      subject
      expect(json_data.first['attributes']).to eq({
        'value' => rating.value
      })
    end

    it 'should have related objects information in the response' do
      user = create :user
      create :rating, post: post1, user: user
      subject
      relationships = json_data.first['relationships']
      expect(relationships['post']['data']['id'].to_i).to eq(post1.id)
      expect(relationships['user']['data']['id'].to_i).to eq(user.id)
    end
  end

  describe "POST #create" do
    context 'when not authorized' do
      subject { post :create, params: { post_id: post1.id } }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:valid_attributes) do
        { data: { attributes: { value: 1} } }
      end

      let(:invalid_attributes) { { data: { attributes: { value: '' } } } }

      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      let(:json){JSON.parse(response.body)}

      before do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(user)
      end

      context "with valid params" do
        subject do
          post :create, params: valid_attributes.merge(post_id: post1.id)
        end

        it 'returns 201 status code' do
          subject
          expect(response).to have_http_status(:created)
        end

        it "creates a new rating" do
          expect { subject }.to change(post1.ratings, :count).by(1)
        end
      end
      context "with invalid params" do
        subject do
          post :create, params: invalid_attributes.merge(post_id: post1.id)
        end
  
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it "renders a JSON response with errors for the new rating" do
          subject
          expect(json['errors'][1]['code']).to eq('not_a_number')
         end
      end
    end

  end
end
