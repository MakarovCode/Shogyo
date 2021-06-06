class AddCountryIdToPosts < ActiveRecord::Migration::Current
  def change
    add_reference :posts, :country, foreign_key: true
  end
end
