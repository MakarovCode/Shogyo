class CreateConsultCategories < ActiveRecord::Migration::Current
  def change
    create_table :consult_categories do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
