class AddFacebookCommentsLinkToPosts < ActiveRecord::Migration::Current
  def change
    add_column :posts, :facebook_comments_link, :text
  end
end
