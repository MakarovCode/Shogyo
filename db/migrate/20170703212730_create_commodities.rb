class CreateCommodities < ActiveRecord::Migration::Current
  def change
    create_table :commodities do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
