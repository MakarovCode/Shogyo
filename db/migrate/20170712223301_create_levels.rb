class CreateLevels < ActiveRecord::Migration::Current
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :min
      t.integer :max
      t.integer :number
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
