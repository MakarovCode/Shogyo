class CreateAds < ActiveRecord::Migration::Current
  def change
    create_table :ads do |t|
      t.string :title
      t.string :image
      t.text :content
      t.string :link
      t.integer :views_count, default: 0
      t.integer :clicks_count, default: 0
      t.datetime :start_date
      t.datetime :end_date
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
