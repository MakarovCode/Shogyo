class AddSubcategoryIdToPublications < ActiveRecord::Migration::Current
  def change
    add_reference :publications, :subcategory, foreign_key: true
  end
end
