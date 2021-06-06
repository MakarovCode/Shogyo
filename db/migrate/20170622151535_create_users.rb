class CreateUsers < ActiveRecord::Migration::Current
  def change
    create_table :users do |t|
      t.string :name
      t.date :birthdate
      t.references :city, foreign_key: true
      t.string :profession
      t.string :phone
      t.string :address
      t.string :main_activity
      t.integer :status

      t.timestamps
    end
  end
end
