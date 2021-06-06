class CreateFeedbacks < ActiveRecord::Migration::Current
  def change
    create_table :feedbacks do |t|
      t.references :user, foreign_key: true
      t.references :publication, foreign_key: true
      t.string :subject
      t.text :details
      t.integer :status

      t.timestamps
    end
  end
end
