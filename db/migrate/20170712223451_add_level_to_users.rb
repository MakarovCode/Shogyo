class AddLevelToUsers < ActiveRecord::Migration::Current
  def change
    add_reference :users, :level, foreign_key: true
  end
end
