class AddConsultManagerToUsers < ActiveRecord::Migration::Current
  def change
    add_column :users, :consult_manager, :boolean, default: false
  end
end
