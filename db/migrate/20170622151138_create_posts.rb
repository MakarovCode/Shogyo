class CreatePosts < ActiveRecord::Migration::Current
  def change
    create_table :posts do |t|
      t.string :title
      t.string :image
      t.string :video
      t.text :abstract
      t.text :content
      t.date :date
      t.boolean :is_news
      t.integer :status
      t.string :author

      t.timestamps
    end
  end
end
