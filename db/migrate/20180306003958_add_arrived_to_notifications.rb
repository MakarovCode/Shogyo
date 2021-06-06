class AddArrivedToNotifications < ActiveRecord::Migration::Current
  def change
    add_column :notifications, :arrived, :boolean, default: false
  end
end
