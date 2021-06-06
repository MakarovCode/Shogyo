class AddRepFieldsToPurchases < ActiveRecord::Migration::Current
  def change
    add_column :purchases, :delivered, :boolean
    add_column :purchases, :buyer_recommended, :integer
    add_column :purchases, :buyer_review, :text
    add_column :purchases, :reviewed, :boolean
    add_column :purchases, :buyer_reviewed, :boolean
  end
end
