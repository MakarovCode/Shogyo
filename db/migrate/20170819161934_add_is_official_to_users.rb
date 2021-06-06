class AddIsOfficialToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :is_official, :boolean
    add_column :users, :is_certified, :boolean
  end
end
