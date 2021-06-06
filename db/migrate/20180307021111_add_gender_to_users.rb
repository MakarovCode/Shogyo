class AddGenderToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :gender, :string
  end
end
