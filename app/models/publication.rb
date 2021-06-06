class Publication < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  belongs_to :user
  belongs_to :subcategory
  belongs_to :city
  belongs_to :plan

  has_many :purchases
  has_many :publication_tags
  has_many :tags, through: :publication_tags

  has_many :publication_images, dependent: :destroy
  has_many :publication_questions, dependent: :destroy

  accepts_nested_attributes_for :tags
  accepts_nested_attributes_for :publication_images, :allow_destroy => true

  validates :title, length: {minimum: 20, maximum: 100}, :if => Proc.new { |a| (a.step == 2) }

  validates :subject, :subcategory_id, presence: true, :if => Proc.new { |a| (a.step == 1) }
  validates :title, :description, :city_id, :address, presence: true, :if => Proc.new { |a| (a.step == 2) }
  validates :kind, presence: true, :if => Proc.new { |a| (a.step == 2 && a.subject != SERVICIOS && a.subject != ANIMALES) }
  validates :year, :brand, :model, :transmission, :cylinder, :color, :fuel_type, presence: true, :if => Proc.new { |a| (a.step == 2 && a.subject == VEHICULOS) }
  validates :total_mtr, :builded_mtr, :estrato, :admin_price, presence: true, :if => Proc.new { |a| (a.step == 2 && a.subject == INMUEBLES) }
  #validates :age, presence: true, :if => Proc.new { |a| (a.step == 2 && a.subject == ANIMALES) }
  validates :age, numericality: {greater_than_or_equal_to: 0}, :if => Proc.new { |a| (a.step == 2 && a.subject == ANIMALES) }

  # validates :shipping, presence: true, :if => Proc.new { |a| (a.step == 3 && a.subject == PRODUCTOS && (a.pickup == false || a.pickup.nil?)) }
  # validates :shipping, presence: true, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject == PRODUCTOS && (a.pickup == false || a.pickup.nil?)) }
  #validates :shipping_price, presence: true, :if => Proc.new {|a| (a.step == 3 && a.shipping == true) }
  validates :shipping_price, numericality: {greater_than_or_equal_to: 1000}, :if => Proc.new { |a| (a.step == 3 && !a.shipping_price.nil? && a.shipping_price > 0 ) }

  validates :start_date, presence: true, :if => Proc.new { |a| (a.step == 3) }

  validates :price, presence: true, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject == SERVICIOS && (a.to_agree == false || a.to_agree.nil?) )}
  validates :price, presence: true, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject == ANIMALES && (a.for_adoption == false || a.for_adoption.nil?) )}
  validates :price, presence: true, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject != ANIMALES && a.subject != SERVICIOS )}

  validates :price, numericality: {greater_than_or_equal_to: 100}, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject != ANIMALES && a.subject != SERVICIOS && a.price.present? )}
  validates :price, numericality: {greater_than_or_equal_to: 100}, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject != ANIMALES && a.subject != SERVICIOS && a.price.present? )}
  validates :price, numericality: {greater_than_or_equal_to: 100}, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject != ANIMALES && a.subject != SERVICIOS && a.price.present? )}

  # validates :price, numericality: {greater_than_or_equal_to: 0}, :if => Proc.new { |a| (a.step == 3) }
  validates :units, presence: true, :if => Proc.new { |a| (a.step == 3 && a.subject == PRODUCTOS ) }
  validates :units, numericality: {greater_than_or_equal_to: 0}, :if => Proc.new { |a| (a.step == 3 && a.subject == PRODUCTOS) }
  validates :warranty_description, presence: true, :if => Proc.new { |a| (a.step == 3 && a.subject == PRODUCTOS && a.warranty == true) }
  validates :lot_size, presence: true, :if => Proc.new { |a| (a.step == 3 && a.subject == ANIMALES && a.is_lot == true) }

  validates :pickup, presence: true, :if => Proc.new { |a| (a.step == 3 && a.in_need != true && a.subject == PRODUCTOS && (a.shipping == false || a.shipping.nil?)) }

  # validates :title, :description, :units, :city_id, :subcategory_id

  attr_accessor :tag_ids_str

  # START ------ SEARCHKICK ELASTICSEARCH

  searchkick language: "spanish",
  callbacks: :async,
  suggest: [:title, :subcategory_name, :category_name],
  searchable: [:title, :subcategory_name, :category_name]

  scope :search_import, -> { includes([{city: :department}, {subcategory: :category}]) }

  after_commit :reindex_publication
  before_save :camelcasing

  def camelcasing
    self.title = self.title.titleize unless self.title.nil?
    # self.description = self.description.capitalize unless self.description.nil?
    self.warranty_description = self.warranty_description.capitalize unless self.warranty_description.nil?
  end

  def reindex_publication
    self.reindex # or reindex_async
  end

  def search_data
    if subcategory.synonims == "" || subcategory.synonims.nil?
      subcategory_name = subcategory.name
    else
      subcategory_name = "#{subcategory.name} (#{subcategory.synonims.nil? ? '' : subcategory.synonims.gsub(',', ', ')})"
    end

    if subcategory.category.synonims == "" || subcategory.category.synonims.nil?
      category_name = subcategory.category.name
    else
      category_name = "#{subcategory.category.name} (#{subcategory.category.synonims.nil? ? '' : subcategory.category.synonims.gsub(',', ', ')})"
    end

    {
      title: title,
      status: status,
      kind: kind == 1 ? 'Nuevo' : "Usado",
      subject: subject,
      city_name: city.nil? ? 'No registra' : "#{city.department.name.downcase.camelcase}",
      subcategory_name: subcategory_name,
      category_name: category_name,
      visits_count: visits_count
    }
  end

  # END ------- SEARCHKICK ELASTICSEARCH

  SERVICIOS = "Servicios"
  VEHICULOS = "Vehiculos y Remolques"
  INMUEBLES = "Inmuebles y Terrenos"
  PRODUCTOS = "Productos y Otros"
  ANIMALES = "Animales"

  def self.getSubjectFromInt(value)
    if value == "1"
      SERVICIOS
    elsif value == "2"
      VEHICULOS
    elsif value == "3"
      INMUEBLES
    elsif value == "4"
      PRODUCTOS
    else value == "5"
      ANIMALES
    end
  end

  def getSubjectSingular
    if subject == SERVICIOS
      "Servicio"
    elsif subject == VEHICULOS
      "Vehiculo"
    elsif subject == INMUEBLES
      "Inmueble y/o terreno"
    elsif subject == PRODUCTOS
      "Producto"
    else
      "Animal"
    end
  end

  def self.pending
    where status: [0, nil]
  end

  def self.actives
    where(status: 1)
  end

  def self.ready
    where("status = ? AND start_date <= ?", 1, Date.today)
  end

  def self.paused
    where status: 2
  end

  def self.finished
    where status: 3
  end

  def self.deleted
    where status: 4
  end

  def get_status
    if self.status == nil? || self.status == 0
      "Pendiente"
    elsif self.status == 1
      "Activo"
    elsif self.status == 2
      "Pausado"
    elsif self.status == 3
      "Finalizado"
    else
      "Eliminado"
    end
  end

  def get_kind
    unless self.in_need == true
      if self.subject != ANIMALES && self.subject != SERVICIOS
        if self.kind == 1
          "Nuevo"
        else
          "Usado"
        end
      elsif self.subject == ANIMALES
        if self.for_adoption == true
          "En adopción"
        else
          "En venta"
        end
      else
        if self.to_agree == true
          "Precio a convenir"
        else
          "Precio fijo"
        end
      end
    else
      "Se busca"
    end
  end

  def get_mode
    if mode == 1
      "Se vender"
    else
      "Se arrienda"
    end
  end

  def get_shipping
    "Envio a todo el país"
  end

  def get_points
    points = 10
    if self.to_agree == true
      points = 20
    elsif self.for_adoption == true
      points = 20
    elsif self.in_need == true
      points = 20
    else
      value = (self.price / 2000.0).ceil
      if value > 10 && value <= 2500
        points = value
      elsif value > 2500
        points = 2500
      end
    end
    points
  end

  def get_image(type)
    url = nil
    image = publication_images.first
    if image.nil?
      url = Rails.application.routes.url_helpers.root_url  + "/" + ActionController::Base.helpers.asset_url("no-image.png")
    else
      if type == "mid"
        url = image.source.mid.url
      elsif type == "mid_original"
        url = image.source.mid_original.url
      elsif type == "high"
        url = image.source.high.url
      else
        url = image.source.low.url
      end
    end
    url = "no-image.png" if url.nil?
    url
  end

  def self.random_images
    all.each do |publication|
    end
  end

  def get_currency_precision
    unless self.city.nil?
      unless self.city.department.nil?
        unless self.city.department.country_id.nil?
          if self.city.department.country_id == 2
            return 2
          end
        end
      end
    end
    return 0
  end

  def get_currency_unit
    unless self.city.nil?
      unless self.city.department.nil?
        unless self.city.department.country_id.nil?
          if self.city.department.country_id == 2
            return "€"
          end
        end
      end
    end
    return "$"
  end

  def check_if_ended(purchase)
    if subject == PRODUCTOS
      sold_units = purchases.where(reviewed: true, buyer_reviewed: true).sum(:units)
      if sold_units >= units
        update_attribute :status, 3
        Notification.create_and_send(Notification::PUBLICATION_ENDED, purchase.publication, purchase.publication.user)
      end
    else
      if purchase.reviewed == true && purchase.buyer_reviewed == true
        update_attribute :status, 3
        Notification.create_and_send(Notification::PUBLICATION_ENDED, purchase.publication, purchase.publication.user)
      end
    end
  end

  def self.start_publications_notification
    Publication.where(start_date: Date.today).where.not(created_at: Date.today.at_beginning_of_day..Date.today.at_end_of_day).each do |publication|
      Notification.create_and_send(Notification::PUBLICATION_STARTED, publication, publication.user)
    end
  end

  def self.end_publications_notification
    Publication.includes(:user).where(end_date: Date.today).where.not({users: {is_official: true}}).where.not({publications: {subject: Publication::SERVICIOS}}).references(:user).each do |publication|
      publication.update_attribute :status, 3
      Notification.create_and_send(Notification::PUBLICATION_ENDED, publication, publication.user)
    end
  end

end
