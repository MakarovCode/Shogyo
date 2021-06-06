class AddSubjectToCategories < ActiveRecord::Migration::Current
  def change
    add_column :categories, :subject, :string
    add_column :publications, :subject, :string
  end
end
