class CreateCities < ActiveRecord::Migration::Current
  def change
    create_table :cities do |t|
      t.string :name
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
