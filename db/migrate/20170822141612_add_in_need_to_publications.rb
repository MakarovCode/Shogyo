class AddInNeedToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :in_need, :boolean
  end
end
