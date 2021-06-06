ActiveAdmin.register Interest do

  actions :all, except: [:show]

  # active_admin_import

  menu parent: 'Datos maestros'

  index do
    column :id
    column :name
    column :description
    column :categories do |interest|
      ul do
        interest.categories.each do |category|
          li do
            category.name
          end
        end
      end
    end
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :name
      f.input :description
      f.input :categories, as: :check_boxes, collection: Category.all.map{|a| ["#{a.name} - #{a.for_news == true ? 'Noticias' : 'Mercado'}", a.id]}
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
