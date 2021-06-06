class CreateUserConsultQuestionVotes < ActiveRecord::Migration::Current
  def change
    create_table :user_consult_question_votes do |t|
      t.references :user, foreign_key: true
      t.references :consult_question, foreign_key: true
      t.integer :points
      t.timestamps
    end
  end
end
