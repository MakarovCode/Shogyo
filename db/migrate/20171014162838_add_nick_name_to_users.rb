class AddNickNameToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :nickname, :string
    add_index :users, :nickname
  end
end
