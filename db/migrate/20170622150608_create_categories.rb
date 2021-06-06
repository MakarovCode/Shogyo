class CreateCategories < ActiveRecord::Migration::Current
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
