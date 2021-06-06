class AddCountryIdToUsers < ActiveRecord::Migration::Current
  def change
    add_reference :users, :country, foreign_key: true
  end
end
