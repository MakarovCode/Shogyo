class AddMoreFieldsToNotifications < ActiveRecord::Migration::Current
  def change
    add_column :notifications, :email_engaged, :boolean
    add_column :notifications, :object_id, :integer
    add_column :notifications, :object_type, :string
    add_column :notifications, :link, :string
  end
end
