class AddSomeFieldsToCommodities < ActiveRecord::Migration::Current
  def change
    add_column :commodities, :priority, :integer
    add_column :variations, :currency, :string
  end
end
