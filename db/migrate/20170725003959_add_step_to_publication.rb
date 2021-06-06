class AddStepToPublication < ActiveRecord::Migration::Current
  def change
    add_column :publications, :step, :integer
  end
end
