class CreatePlans < ActiveRecord::Migration::Current
  def change
    create_table :plans do |t|
      t.string :name
      t.float :price
      t.integer :visibility_level
      t.boolean :unlimited_time
      t.integer :status

      t.timestamps
    end
  end
end
