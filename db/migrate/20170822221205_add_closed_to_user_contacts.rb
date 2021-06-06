class AddClosedToUserContacts < ActiveRecord::Migration::Current
  def change
    add_column :user_contacts, :closed, :boolean, default: false
  end
end
