class CreateAchivements < ActiveRecord::Migration::Current
  def change
    create_table :achivements do |t|
      t.string :name
      t.string :icon
      t.text :description
      t.integer :points
      t.integer :kind
      t.integer :status

      t.timestamps
    end
  end
end
