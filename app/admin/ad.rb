ActiveAdmin.register Ad do

  actions :all

  menu parent: 'Monetización'

  index do
    column :ad_type
    column :client
    column :title
    column :image do |ad|
      image_tag ad.image.url, height: 80
    end
    column :views_count
    column :clicks_count
    column :start_date
    column :end_date
    actions
  end

  form do |f|
    f.inputs "Información de básica" do
      f.input :client
      f.input :title
      f.input :image
      f.input :content
      f.input :link
      f.input :start_date, as: :date_time_picker
      f.input :end_date, as: :date_time_picker
      f.input :ad_type, as: :select, collection: [["Principal superior", "01"], ["Secundario cuadrado", "02"], ["Tercer cuadrado", "03"], ["Primer Item Landing", "04"], ["Móvil Cover", "05"], ["Móvil Top Banner", "06"]]
    end
    actions
  end

  show do
    # renders app/views/admin/posts/_some_partial.html.erb
    render 'show', { ad: ad }
  end

  controller do
    before_action :protected_attributes
    def protected_attributes
      params.permit!
    end

    def show
      @ad = Ad.find params[:id]
      events = Ahoy::Event.includes(:visit).where("properties ->> 'ad_id' = '#{@ad.id}' OR properties ->> 'title' = '#{@ad.id} - #{@ad.title}'")
      @views = events.where(name: "Viewed ad")
      @clicks = events.where(name: "Clicked ad")
    end

  end

end
