class AddColorToCategories < ActiveRecord::Migration::Current
  def change
    add_column :categories, :color, :string
  end
end
