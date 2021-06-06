class CreateClients < ActiveRecord::Migration::Current
  def change
    create_table :clients do |t|
      t.string :name
      t.string :contact

      t.timestamps
    end
  end
end
