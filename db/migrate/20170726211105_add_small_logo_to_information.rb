class AddSmallLogoToInformation < ActiveRecord::Migration::Current
  def change
    add_column :information, :small_logo, :string
  end
end
