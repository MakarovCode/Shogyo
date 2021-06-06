class CreateSubcategories < ActiveRecord::Migration::Current
  def change
    create_table :subcategories do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
