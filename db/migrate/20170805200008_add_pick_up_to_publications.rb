class AddPickUpToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :pickup, :boolean
  end
end
