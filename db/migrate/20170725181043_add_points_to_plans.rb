class AddPointsToPlans < ActiveRecord::Migration::Current
  def change
    add_column :plans, :points, :integer
    add_column :plans, :icon, :string
    add_column :plans, :color, :string
    add_column :plans, :description, :text
    add_column :plans, :priority, :integer
  end
end
