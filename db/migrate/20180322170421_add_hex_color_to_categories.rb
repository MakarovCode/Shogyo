class AddHexColorToCategories < ActiveRecord::Migration::Current
  def change
    add_column :categories, :hex_color, :string, default: "#0F6A37"
  end
end
