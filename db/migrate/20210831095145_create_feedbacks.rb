class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.text :comment
      t.belongs_to :owner, polymorphic: true

      t.timestamps
    end
    add_index :feedbacks, %i[owner_id owner_type]
  end
end
