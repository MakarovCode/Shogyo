class AddMeasureUnitToPublication < ActiveRecord::Migration::Current
  def change
    add_column :publications, :measure_unit, :string
  end
end
