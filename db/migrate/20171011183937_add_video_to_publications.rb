class AddVideoToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :video, :string
  end
end
