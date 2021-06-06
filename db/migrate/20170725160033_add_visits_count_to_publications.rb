class AddVisitsCountToPublications < ActiveRecord::Migration::Current
  def change
    add_column :publications, :visits_count, :integer, default: 0
  end
end
