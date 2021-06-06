class AddSynonimsToSubcategories < ActiveRecord::Migration::Current
  def change
    add_column :subcategories, :synonims, :string, default: ""
    add_column :categories, :synonims, :string, default: ""
  end
end
