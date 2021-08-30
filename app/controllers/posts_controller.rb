class PostsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]

  def index
    posts = Post.recent
                .page(current_page)
                .per(per_page)
    render jsonapi: posts
  end

  def create
    post = current_user.posts.build(post_params.merge(ip_address: request.remote_ip))
    post.save!
    render jsonapi: post, status: :created
  rescue ActiveRecord::RecordInvalid
    render jsonapi_errors: post.errors, status: :unprocessable_entity
  end

  def update
    post = current_user.posts.find(params[:id])
    post.update!(post_params.merge(ip_address: request.remote_ip))
    render jsonapi: post, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue ActiveRecord::RecordInvalid
    render jsonapi_errors: post.errors,
           status: :unprocessable_entity
  end

  def show
    render jsonapi: Post.find(params[:id])
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    head :no_content
  rescue StandardError
    authorization_error
  end

  private

  def post_params
    params.require(:data).require(:attributes)
          .permit(:title, :content) ||
      ActionController::Parameters.new
  end
end
