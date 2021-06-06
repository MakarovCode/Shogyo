ActiveAdmin.register Post do

  actions :all, except: [:show]

  index do
    column :title
    column :image do |r|
      image_tag r.image.url, height: 80
    end
    column :video
    column :author
    column :abstract
    column :is_news
    column :date
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
      # f.input :scope_location, as: :select, collection: [["Internacional", "Internacional"]]
      f.input :country
      f.input :author
      f.input :title
      f.input :image, hint: "Resolución esperada 800x600"
      f.input :video_file, hint: "Acá debe ir un archivo de video (Opcional)."
      f.input :video, hint: "En este campo deben copiar el link EMBEDED dado por YouTube."
      f.input :abstract
      f.input :content 
      f.input :content2 , hint: "Este es el texto que aparece al dar en Leer más dentro de la noticia, para bajar la tasa de rebote"
      f.input :date, as: :datepicker
      f.input :facebook_comments_link
      # f.input :is_news
      f.input :subcategory_ids, as: :tags, collection: Subcategory.all.order("name ASC").map{|s| {"id": s.id, "text": "#{s.name} (#{s.category.name})"}}
      f.input :tag_ids, as: :tags, collection: Tag.all, display_name: :name
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
