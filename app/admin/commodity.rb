ActiveAdmin.register Commodity do

  actions :all, except: [:show]

  menu parent: 'Economía'

  index do
    column :name
    column :icon
    column :priority
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :name
      f.input :icon
      f.input :priority
      # f.input :status, as: :select, collection: [["Activo", 0], ["Inactivo", 1]]
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
