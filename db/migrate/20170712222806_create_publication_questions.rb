class CreatePublicationQuestions < ActiveRecord::Migration::Current
  def change
    create_table :publication_questions do |t|
      t.references :publication, foreign_key: true
      t.references :user, foreign_key: true
      t.text :question
      t.text :answer
      t.datetime :answer_time
      t.integer :status

      t.timestamps
    end
  end
end
