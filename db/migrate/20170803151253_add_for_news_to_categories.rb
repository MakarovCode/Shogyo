class AddForNewsToCategories < ActiveRecord::Migration::Current
  def change
    add_column :categories, :for_news, :boolean
  end
end
