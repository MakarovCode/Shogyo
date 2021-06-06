class AddAdTypeToAds < ActiveRecord::Migration::Current
  def change
    add_column :ads, :ad_type, :string
  end
end
