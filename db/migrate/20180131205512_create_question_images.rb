class CreateQuestionImages < ActiveRecord::Migration::Current
  def change
    create_table :consult_question_images do |t|
      t.references :consult_question, foreign_key: true
      t.string :source

      t.timestamps
    end
  end
end
