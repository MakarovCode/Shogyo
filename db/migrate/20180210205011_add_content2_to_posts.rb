class AddContent2ToPosts < ActiveRecord::Migration::Current
  def change
    add_column :posts, :content2, :text
  end
end
