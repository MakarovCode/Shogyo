class AddScopeLocationToPosts < ActiveRecord::Migration::Current
  def change
    add_column :posts, :scope_location, :string
  end
end
