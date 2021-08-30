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
      Post.recent.last do |post, index|
        expect(json_data[index]['attributes']).to eq({
                                                       'title' => post.title,
                                                       'content' => post.content,
                                                       'ip_address' => post.ip_address
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
      expected_post = Post.recent.second.id
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
      expect(json_data['data']['attributes']).to eq({
                                                      'id' => post.id,
                                                      'title' => post.title,
                                                      'content' => post.content,
                                                      'ip_address' => post.ip_address
                                                    })
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
              content: 'new',
              ip_address: 'new'
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
        pp Post.all
      end

      context 'when post is invalid' do
        let(:params) do
          {
            data: {
              attributes: {
                title: 'new',
                content: '',
                ip_address: ''
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
end
