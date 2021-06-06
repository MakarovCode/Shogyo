class CreateFavorites < ActiveRecord::Migration::Current
  def change
    create_table :favorites do |t|
      t.references :publication, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
