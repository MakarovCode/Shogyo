class AddPointsToUserAchivements < ActiveRecord::Migration::Current
  def change
    add_column :user_achivements, :points, :integer
  end
end
