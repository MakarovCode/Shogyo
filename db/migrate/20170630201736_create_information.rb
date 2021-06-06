class CreateInformation < ActiveRecord::Migration::Current
  def change
    create_table :information do |t|
      t.string :logo
      t.string :facebook_link
      t.string :twitter_link
      t.string :linkedin_link
      t.string :youtube_link
      t.string :instagram_link
      t.string :googleplus_link
      t.string :meta_image
      t.string :meta_description
      t.string :meta_keywords
      t.string :blog_tab_title
      t.string :blog_sidebar_title
      t.string :about_us_image
      t.string :about_us_title
      t.text :about_us_content
      t.string :copyrights_text
      t.text :terms
      t.text :policy
      t.text :habeasdata
      t.string :contact_email
      t.string :contact_address
      t.string :contact_phone
      t.string :register_image
      t.string :register_title
      t.text :register_content
      t.string :login_image
      t.string :login_title
      t.text :login_content
      t.string :explanation_image
      t.string :explanation_title
      t.text :explanation_content

      t.timestamps
    end
  end
end
