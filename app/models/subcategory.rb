class Subcategory < ApplicationRecord

  # searchkick suggest: [:name]

  belongs_to :category

  has_many :publications
  has_many :post_subcategories
  has_many :posts, through: :post_subcategories

  def self.actives
    where(status: [nil, 0])
  end

  def self.inactives
    where(status: 1)
  end

  def self.search(term)
    where("subcategories.name iLIKE '%#{term}%' OR subcategories.synonims iLIKE '%#{term}%'")
  end

end
