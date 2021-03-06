class CreateMessages < ActiveRecord::Migration::Current
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :text
      t.string :file
      t.string :tmp_id
      t.boolean :read

      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
