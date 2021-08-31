class RatingsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  before_action :load_post

  def index
    ratings = @post.ratings
                   .page(current_page)
                   .per(per_page)
    render jsonapi: ratings
  end

  def create
    @rating = @post.ratings.build(rating_params.merge(user_id: current_user.id))
    if !rated?
      if @rating.save
        render jsonapi: @rating, status: :created, location: @post
      else
        render jsonapi_errors: @rating.errors,
               status: :unprocessable_entity
      end
    else
      render json: { 'error' => 'rated already' }, status: :unprocessable_entity
    end
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def rating_params
    params.require(:data).require(:attributes)
          .permit(:value) ||
      ActionController::Parameters.new
  end

  def rated?
    res = Rating.where(user_id: current_user.id, post_id: @post.id)
    res.nil?
  end
end
