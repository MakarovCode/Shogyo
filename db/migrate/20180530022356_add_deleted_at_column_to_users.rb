class AddDeletedAtColumnToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :deleted_at, :datetime
  end
end
