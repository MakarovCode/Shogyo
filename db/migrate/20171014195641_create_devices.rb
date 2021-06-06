class CreateDevices < ActiveRecord::Migration::Current
  def change
    create_table :devices do |t|
      t.string :token
      t.string :platform
      t.references :user, index: true, foreign_key: true
      t.string :imei

      t.timestamps null: false
    end
  end
end
