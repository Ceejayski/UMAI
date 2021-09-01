class RemoveOtherFeedbacksFromFeedbacks < ActiveRecord::Migration[6.1]
  def change
    remove_column :feedbacks, :other_feedbacks, :string
  end
end
