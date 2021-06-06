class CreateNotifications < ActiveRecord::Migration::Current
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.text :text
      t.boolean :read
      t.integer :status

      t.timestamps
    end
  end
end
