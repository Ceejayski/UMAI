class AddAvgratingToPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :avg_ratings, :float
  end
end
