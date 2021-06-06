class CreateUserConsultQuestionVisits < ActiveRecord::Migration::Current
  def change
    create_table :user_consult_question_visits do |t|
      t.references :user, foreign_key: true
      t.references :consult_question, foreign_key: true

      t.timestamps
    end
  end
end
