class AddSlugsToModels < ActiveRecord::Migration::Current
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true

    add_column :publications, :slug, :string
    add_index :publications, :slug, unique: true
  end
end
