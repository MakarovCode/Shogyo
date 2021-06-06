ActiveAdmin.register Level do

  actions :all, except: [:show]

  menu parent: 'Gamificación'

  index do
    column :number
    column :name
    column :min
    column :max
    column :description
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
    f.inputs "Información de básica" do
      f.input :number
      f.input :name
      f.input :min
      f.input :max
      f.input :description
      f.input :status, as: :select, collection: [["Activo", 0], ["Inactivo", 1]]
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
