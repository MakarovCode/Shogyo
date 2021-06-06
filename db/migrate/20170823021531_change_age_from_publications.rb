class ChangeAgeFromPublications < ActiveRecord::Migration::Current
  def change
    change_column :publications, :age, :string
  end
end
