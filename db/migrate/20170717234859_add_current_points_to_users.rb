class AddCurrentPointsToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :current_points, :integer, default: 0
  end
end
