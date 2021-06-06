class AddPSomeFieldsToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :start_date, :date
    add_column :publications, :end_date, :date
    add_column :publications, :shipping_price, :float
    add_reference :publications, :city, foreign_key: true
    add_column :publications, :address, :string
    add_reference :publications, :plan, foreign_key: true
  end
end
