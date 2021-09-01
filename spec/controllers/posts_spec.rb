require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:json_data) { JSON.parse(response.body) }
  describe '#index' do
    subject { get :index }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      create_list :post, 1
      subject
      Post.highest_rated.last do |post, index|
        expect(json_data[index]['attributes']).to eq({
                                                       'title' => post.title,
                                                       'content' => post.content

                                                     })
      end
    end

    it 'should return posts in the proper order' do
      old_post = create :post
      newer_post = create :post
      subject
      expect(json_data['data'].first['id'].to_i).to eq(newer_post.id)
      expect(json_data['data'].last['id'].to_i).to eq(old_post.id)
    end

    it 'should paginate results' do
      create_list :post, 3
      get :index, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq 1
      expected_post = Post.highest_rated.second.id
      expect(json_data['data'].first['id'].to_i).to eq(expected_post)
    end
  end

  describe '#show' do
    let(:post) { create :post }
    subject { get :show, params: { id: post.id } }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      subject
      expect(json_data['data']['attributes']['avg_ratings']).to eq( 8)
    end
  end

  describe '#create' do
    subject { post :create }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:params) do
        {
          data: {
            attributes: {
              title: 'new',
              content: 'new'

            }
          }
        }
      end
      subject { post :create, params: params }
      let(:user) { create :user }
      before do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(user)
      end

      it 'when success request sent' do
        expect(response).to have_http_status(:ok)
      end

      it 'when post is valid' do
        subject
        pp json_data
        expect(response).to have_http_status(201)
      end

      context 'when post is invalid' do
        let(:params) do
          {
            data: {
              attributes: {
                title: 'new',
                content: ''

              }
            }
          }
        end
        it_behaves_like 'unprocessable_details'
        it 'should fail when content and ip_address are empty' do
          subject
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe '#update' do
    let(:post) { create :post }
    subject { patch :update, params: { id: post.id } }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end
    context 'when authorised' do
      let(:user) { create :user }
      let(:user2) { create :user }
      let(:post) { create :post, user: user }
      let(:post2) { create :post, user: user2 }
      let(:params) do
        {
          id: post.id,
          data: {
            attributes: {
              title: 'new',
              content: 'new'
            }
          }
        }
      end
      before do
        allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(user)
      end
      subject { patch :update, params: params }
      context "when user tries to edit someone else's post" do
        let(:params) do
          {
            id: post2.id,
            data: {
              attributes: {
                title: 'new',
                content: 'new'
              }
            }
          }
        end
        it_behaves_like 'forbidden_requests'
      end
      context 'when invalid parameters provided' do
        let(:invalid_attributes) do
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
        subject do
          patch :update, params: invalid_attributes.merge(id: post.id)
        end
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json_data['errors']).to eq(
            [{ 'code' => 'blank',
               'detail' => "Title can't be blank",
               'source' => { 'pointer' => '/data/attributes/title' },
               'status' => '422',
               'title' => 'Unprocessable Entity' },
             { 'code' => 'blank',
               'detail' => "Content can't be blank",
               'source' => { 'pointer' => '/data/attributes/content' },
               'status' => '422',
               'title' => 'Unprocessable Entity' }]
          )
        end
      end
      context 'when valid parameters are given' do
        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'Awesome post',
                'content' => 'Super content'
              }
            }
          }
        end
        subject do
          patch :update, params: valid_attributes.merge(id: post.id)
        end
        it 'should have 200 status code' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'should have proper json body' do
          subject
          expect(json_data['data']['attributes']).to include(
            valid_attributes['data']['attributes']
          )
        end
        it 'should update the post' do
          subject
          expect(post.reload.title).to eq(
            valid_attributes['data']['attributes']['title']
          )
        end
      end
    end
  end
end
