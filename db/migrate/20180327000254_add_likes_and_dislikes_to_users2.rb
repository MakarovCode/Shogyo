class AddLikesAndDislikesToUsers2 < ActiveRecord::Migration::Current
  def change
    change_column :users, :likes, :integer, default: 0
    change_column :users, :dislikes, :integer, default: 0
  end
end
