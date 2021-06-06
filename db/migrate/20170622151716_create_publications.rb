class CreatePublications < ActiveRecord::Migration::Current
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.text :content
      t.integer :kind
      t.integer :mode
      t.float :price
      t.integer :units
      t.integer :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
