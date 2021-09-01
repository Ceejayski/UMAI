class AddAvgRatingToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :avg_ratings, :float, default: 0
  end
end
