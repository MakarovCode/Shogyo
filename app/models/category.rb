class Category < ApplicationRecord

  # searchkick suggest: [:name]

  has_many :subcategories, -> { order(name: :asc) }
  has_many :interest_categories
  has_many :interests, through: :interest_categories

  def self.by_subject(subject)
    where("subject iLIKE '%#{subject}%'")
  end

  def self.for_news
    where for_news: true
  end
end
