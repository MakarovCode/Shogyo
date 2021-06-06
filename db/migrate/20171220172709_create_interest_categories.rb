class CreateInterestCategories < ActiveRecord::Migration::Current
  def change
    create_table :interest_categories do |t|
      t.references :interest, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
