class AddFlagToCountries < ActiveRecord::Migration::Current
  def change
    add_column :countries, :flag, :string
  end
end
