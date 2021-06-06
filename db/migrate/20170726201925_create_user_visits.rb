class CreateUserVisits < ActiveRecord::Migration::Current
  def change
    create_table :user_visits do |t|
      t.references :user, foreign_key: true
      t.references :publication, foreign_key: true

      t.timestamps
    end
  end
end
