class CreatePublicationImages < ActiveRecord::Migration::Current
  def change
    create_table :publication_images do |t|
      t.string :source
      t.integer :status

      t.timestamps
    end
  end
end
