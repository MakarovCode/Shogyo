class BdExtensions < ActiveRecord::Migration::Current
  def change
    enable_extension "unaccent"
  end
end
