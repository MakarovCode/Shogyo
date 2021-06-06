ActiveAdmin.register Plan do

  actions :all, except: [:show]

  menu parent: 'Monetización'

  index do
    column :priority
    column :name
    column :price
    column :points
    column :visibility_level
    column :unlimited_time
    column :status do |r|
      if r.status.nil? || r.status == 0
        "Activo"
      else
        "Inactivo"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Información básica" do
      f.input :priority
      f.input :name
      f.input :icon
      f.input :color, as: :string
      f.input :price
      f.input :points
      f.input :visibility_level, as: :select, collection: [["Bajo", 1], ["Medio", 2], ["Alto", 3]]
      f.input :unlimited_time
      f.input :description 
    end
    actions
  end


  controller do
    before_action :protected_attributes
    def protected_attributes
      params.permit!
    end
  end

end
