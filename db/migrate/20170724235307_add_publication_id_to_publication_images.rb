class AddPublicationIdToPublicationImages < ActiveRecord::Migration::Current
  def change
    add_reference :publication_images, :publication, foreign_key: true
  end
end
