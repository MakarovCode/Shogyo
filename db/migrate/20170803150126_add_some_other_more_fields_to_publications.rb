class AddSomeOtherMoreFieldsToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :with_ac, :boolean
    add_column :publications, :uniq_owner, :boolean
    add_column :publications, :to_agree, :boolean
    add_column :publications, :willing_to_move, :boolean
    add_column :publications, :for_adoption, :boolean
    add_column :publications, :is_lot, :boolean
    add_column :publications, :lot_size, :integer
    add_column :publications, :age, :integer
  end
end
