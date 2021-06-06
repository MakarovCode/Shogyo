class AddSomeMoreFieldsToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :year, :integer
    add_column :publications, :brand, :string
    add_column :publications, :km, :integer
    add_column :publications, :model, :string
    add_column :publications, :transmission, :string
    add_column :publications, :cylinder, :integer
    add_column :publications, :color, :string
    add_column :publications, :fuel_type, :string
    add_column :publications, :number, :string
    add_column :publications, :total_mtr, :float
    add_column :publications, :builded_mtr, :float
    add_column :publications, :estrato, :integer
    add_column :publications, :admin_price, :float
    add_column :publications, :characteristics, :string
    add_column :publications, :shipping, :boolean
    add_column :publications, :warranty, :boolean
    add_column :publications, :warranty_description, :text
  end
end
