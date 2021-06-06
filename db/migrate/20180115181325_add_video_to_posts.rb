class AddVideoToPosts < ActiveRecord::Migration::Current
  def change
    add_column :posts, :video_file, :string
  end
end
