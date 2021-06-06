class CreatePurchases < ActiveRecord::Migration::Current
  def change
    create_table :purchases do |t|
      t.references :publication, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status
      t.text :review
      t.integer :received
      t.integer :recommended
      t.string :address
      t.references :city, foreign_key: true
      t.string :phone
      t.boolean :shipping
      t.integer :units

      t.timestamps
    end
  end
end
