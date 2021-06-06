ActiveAdmin.register Achivement do

  actions :all, except: [:show]

  menu parent: 'Gamificación'

  index do
    column :name
    column :icon do |a|
      image_tag a.icon.url, width: 70
    end
    column :points
    column :description
    column :kind
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
      f.input :name
      f.input :icon
      f.input :points
      f.input :description
      f.input :kind, as: :select, collection: [["Bronce", 1], ["Plata", 2], ["Oro", 3]]
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
