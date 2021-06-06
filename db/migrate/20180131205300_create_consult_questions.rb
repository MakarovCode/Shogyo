class CreateConsultQuestions < ActiveRecord::Migration::Current
  def change
    create_table :consult_questions do |t|
      t.text :text
      t.references :user, foreign_key: true
      t.integer :points
      t.integer :visits_count
      t.references :consult_category, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
