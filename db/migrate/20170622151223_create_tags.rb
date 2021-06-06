class CreateTags < ActiveRecord::Migration::Current
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
