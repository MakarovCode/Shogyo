class AddSomeMoreFieldsToPurchases < ActiveRecord::Migration::Current
  def change
    add_column :purchases, :price, :float
    add_column :purchases, :send_status, :boolean
    add_column :purchases, :charge_status, :boolean
    add_column :purchases, :pay_status, :boolean
  end
end
