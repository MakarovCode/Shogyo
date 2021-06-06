class CreateUserAchivements < ActiveRecord::Migration::Current
  def change
    create_table :user_achivements do |t|
      t.references :user, foreign_key: true
      t.references :achivement, foreign_key: true

      t.timestamps
    end
  end
end
