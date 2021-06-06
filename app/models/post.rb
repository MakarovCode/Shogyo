class Post < ApplicationRecord

  belongs_to :country

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  has_many :post_tags
  has_many :tags, through: :post_tags

  has_many :post_subcategories
  has_many :subcategories, through: :post_subcategories


  accepts_nested_attributes_for :tags

  mount_uploader :image, ImageUploader
  mount_uploader :video_file, VideoUploader

  validates :image, file_size: { less_than_or_equal_to: 2.megabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png'] }

  attr_accessor :tag_ids_str, :subcategory_ids_str

  validates :title, :image, :abstract, :content, :content2, :date, :country_id, presence: true

  # START ------ SEARCHKICK ELASTICSEARCH

  searchkick language: "spanish",
  callbacks: :async,
  suggest: [:title, :abstract, :content, :content2, :subcategory_name, :category_name],
  searchable: [:title, :abstract, :content, :content2, :subcategory_name, :category_name]

  scope :search_import, -> { includes([{subcategories: :category}]) }

  after_commit :reindex_publication

  def reindex_publication
    self.reindex # or reindex_async
  end

  def search_data
    subcategories_names = ""
    categories_names = ""
    subcategories.each do |sub|
      if sub.synonims == "" || sub.synonims.nil?
        subcategories_names = "#{subcategories_names} #{sub.name}"
      else
        subcategories_names = "#{subcategories_names} #{sub.name} (#{sub.synonims.nil? ? '' : sub.synonims.gsub(',', ', ')}"
      end

      if sub.category.synonims == "" || sub.category.synonims.nil?
        category_names = "#{categories_names} #{sub.category.name}"
      else
        category_names = "#{categories_names} #{sub.category.name} (#{sub.category.synonims.nil? ? '' : sub.category.synonims.gsub(',', ', ')})"
      end
    end

    {
      title: title,
      abstract: abstract,
      content: content,
      content2: content2,
      status: status,
      subcategory_name: subcategories_names,
      category_name: categories_names,
      visits_count: views_count
    }
  end

  def self.actives
    where(status: [0,nil]).where("date <= ?", Time.now.in_time_zone)
  end

  def self.inactives
    where status: 1
  end

  def get_scope
    if scope_location.nil?
      if country.nil?
        "Internacional"
      else
        country.name
      end
    else
      if country.nil?
        scope_location
      else
        country.name
      end
    end
  end

  def self.smarth_search(tag, category, subcategory)
    posts = []
    unless category.nil?
      posts = includes(:subcategories).where({subcategories: {category_id: category}}).order("posts.date DESC, posts.created_at DESC").references(:subcategories)
    end

    unless subcategory.nil?
      if posts.empty?
        posts = includes(:subcategories).where({subcategories: {id: subcategory}}).order("posts.date DESC, posts.created_at DESC").references(:subcategories)
      else
        posts = posts.includes(:subcategories).where({subcategories: {id: subcategory}}).order("posts.date DESC, posts.created_at DESC").references(:subcategories)
      end
    end

    unless tag.nil?
      if posts.empty?
        posts = includes(:tags).where({tags: {id: tag}}).order("posts.date DESC, posts.created_at DESC").references(:tags)
      else
        posts = posts.includes(:tags).where({tags: {id: tag}}).order("posts.date DESC, posts.created_at DESC").references(:tags)
      end
    end

    if posts.empty?
      if !category.nil? || !subcategory.nil? || !tag.nil?
        posts = where("id != 0").order("posts.date DESC, posts.created_at DESC")
      else
        posts = order("posts.date DESC, posts.created_at DESC")
      end
    end
    posts
  end

end
