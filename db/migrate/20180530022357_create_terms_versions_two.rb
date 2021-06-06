class CreateTermsVersionsTwo < ActiveRecord::Migration::Current
  def change
    add_column :users, :last_terms_notified_at, :datetime
  end
end
