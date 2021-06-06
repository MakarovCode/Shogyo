class CreateConsultAnswerImages < ActiveRecord::Migration::Current
  def change
    create_table :consult_answer_images do |t|
      t.references :consult_answer, foreign_key: true
      t.string :source

      t.timestamps
    end
  end
end
