class PostsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]

  def index
    posts = Post.highest_rated
                .page(current_page)
                .per(per_page)
    render jsonapi: posts
  end

  def create
    post = current_user.posts.build(post_params)
    post.save!
    post.ips.create(ip_address: request.remote_ip, login: current_user.login)
    render jsonapi: post, status: :created
  rescue ActiveRecord::RecordInvalid
    render jsonapi_errors: post.errors, status: :unprocessable_entity
  end

  def update
    post = current_user.posts.find(params[:id])
    post.update!(post_params)
    post.ips.create(ip_address: request.remote_ip, login: current_user.login)
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
