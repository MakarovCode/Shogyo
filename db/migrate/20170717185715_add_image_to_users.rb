class AddImageToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :image, :string
  end
end
