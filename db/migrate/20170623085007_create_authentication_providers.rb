class CreateAuthenticationProviders < ActiveRecord::Migration::Current
  def change
    create_table "authentication_providers", :force => true do |t|
      t.string   "name"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    add_index "authentication_providers", ["name"], :name => "index_name_on_authentication_providers"
    AuthenticationProvider.create(name: 'facebook')
    AuthenticationProvider.create(name: 'twitter')
    AuthenticationProvider.create(name: 'google_oauth2')
    AuthenticationProvider.create(name: 'linkedin_oauth2')
  end
end
