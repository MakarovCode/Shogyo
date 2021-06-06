class AddViewsCountToPosts < ActiveRecord::Migration::Current
  def change
    add_column :posts, :views_count, :integer, default: 0
  end
end
