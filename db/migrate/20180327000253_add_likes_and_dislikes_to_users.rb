class AddLikesAndDislikesToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :likes, :integer, default: 0
    add_column :users, :dislikes, :integer, default: 0
  end
end
