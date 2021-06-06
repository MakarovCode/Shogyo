class CreatePostSubcategories < ActiveRecord::Migration::Current
  def change
    create_table :post_subcategories do |t|
      t.references :post, foreign_key: true
      t.references :subcategory, foreign_key: true

      t.timestamps
    end
  end
end
