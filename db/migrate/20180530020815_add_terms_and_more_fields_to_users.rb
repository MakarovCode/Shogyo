class AddTermsAndMoreFieldsToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :receive_notifications, :boolean, default: true
    add_column :users, :receive_email_ads, :boolean, default: true
    add_column :users, :terms_accepted, :boolean, default: false
    add_column :users, :terms_version_accepted, :string, default: "1.0"
    add_column :users, :last_terms_notified, :boolean, default: false
  end
end
