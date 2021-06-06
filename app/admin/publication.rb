ActiveAdmin.register Publication do

  actions :all, except: [:show]

  filter :title
  filter :kind
  filter :price

  index do
    column :title
    column :description
    column :kind do |r|
      if r.status.nil? || r.status == 0
        "Producto"
      else
        "Servicio"
      end
    end
    column :mode do |r|
      if r.status.nil? || r.status == 0
        "Venta"
      else
        "Compra"
      end
    end
    column :price
    column :units
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
      f.input :plan_id, as: :select, collection: Plan.all.map{|c| [c.name, c.id]}
      f.input :subject, as: :select, collection: [[Publication::SERVICIOS, Publication::SERVICIOS], [Publication::VEHICULOS, Publication::VEHICULOS], [Publication::INMUEBLES, Publication::INMUEBLES], [Publication::PRODUCTOS, Publication::PRODUCTOS], [Publication::ANIMALES, Publication::ANIMALES]]
      f.input :subcategory_id, as: :select, collection: Subcategory.all.order("name ASC").map{|s| ["#{s.name} (#{s.category.name})", s.id]}
      f.input :user
      f.input :title
      f.input :description 
      # f.input :content 
      f.input :kind, as: :select, collection: [["Producto", 0], ["Servicio", 1]]
      f.input :mode, as: :select, collection: [["Venta", 0], ["Compra", 1]]
      f.input :price
      f.input :units
      f.input :start_date
      f.input :end_date
      f.input :shipping_price
      f.input :city_id, as: :select, collection: City.all.map{|c| [c.name, c.id]}
      f.input :address
      f.input :year
      f.input :brand
      f.input :km
      f.input :model
      f.input :transmission
      f.input :cylinder
      f.input :color
      f.input :fuel_type
      f.input :number
      f.input :total_mtr
      f.input :builded_mtr
      f.input :estrato
      f.input :admin_price
      f.input :characteristics
      f.input :shipping
      f.input :warranty
      f.input :warranty_description
      f.input :with_ac
      f.input :uniq_owner
      f.input :to_agree
      f.input :willing_to_move
      f.input :for_adoption
      f.input :is_lot
      f.input :lot_size
      f.input :age
      f.input :pickup
      f.input :in_need
      f.input :status, as: :select, collection: [["Activo", 0], ["Inactivo", 1]]
    end
    f.inputs "Multimedia" do
			f.has_many :publication_images, heading: false, allow_destroy: true, new_record: 'Adicionar Imagen' do |p_form|
				p_form.input :source, hint: "Resolución recomendada: 800x600"
			end
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
