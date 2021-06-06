class CreateConsultAnswers < ActiveRecord::Migration::Current
  def change
    create_table :consult_answers do |t|
      t.text :text
      t.references :user, foreign_key: true
      t.references :consult_question, foreign_key: true
      t.integer :points
      t.integer :status

      t.timestamps
    end
  end
end
