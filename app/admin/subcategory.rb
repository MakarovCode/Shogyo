ActiveAdmin.register Subcategory do

  actions :all, except: [:show]

  menu parent: 'Datos maestros'

  index do
    column :name
    column :category
    column :synonims
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
      f.input :synonims, as: :tags
      f.input :category, as: :select, collection: Category.all.map{|a| ["#{a.name} - #{a.for_news == true ? 'Noticias' : 'Mercado'}", a.id]}
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
