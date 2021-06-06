class CreateTermsVersions < ActiveRecord::Migration::Current
  def change
    create_table :terms_versions do |t|
      t.text :terms
      t.string :version

      t.timestamps
    end
  end
end
