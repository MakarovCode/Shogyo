class CreateVariations < ActiveRecord::Migration::Current
  def change
    create_table :variations do |t|
      t.float :value
      t.date :date
      t.integer :status
      t.references :commodity, foreign_key: true

      t.timestamps
    end
  end
end
