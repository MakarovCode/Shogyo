class CreateInterests < ActiveRecord::Migration::Current
  def change
    create_table :interests do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
