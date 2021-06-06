class AddConsultToPurchases < ActiveRecord::Migration::Current
  def change
    add_column :purchases, :consult, :text
  end
end
