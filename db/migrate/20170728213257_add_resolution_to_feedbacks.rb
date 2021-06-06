class AddResolutionToFeedbacks < ActiveRecord::Migration::Current
  def change
    add_column :feedbacks, :resolution, :text
  end
end
