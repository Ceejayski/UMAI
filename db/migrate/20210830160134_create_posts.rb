class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.string :ip_address
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
