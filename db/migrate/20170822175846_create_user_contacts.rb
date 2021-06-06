class CreateUserContacts < ActiveRecord::Migration::Current
  def change
    create_table :user_contacts do |t|
      t.references :user, foreign_key: true
      t.integer :interested_id
      t.text :message

      t.timestamps
    end
  end
end
