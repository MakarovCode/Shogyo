class ConsultQuestion < ApplicationRecord
  belongs_to :user
  belongs_to :consult_category

  has_many :answers, class_name: "ConsultAnswer", foreign_key: "consult_question_id"

  has_many :consult_question_images
  has_many :user_consult_question_votes
  has_many :user_consult_answers_votes

  validates :text, presence: true

  accepts_nested_attributes_for :consult_question_images

  # START ------ SEARCHKICK ELASTICSEARCH
  after_commit :reindex_publication

  searchkick language: "spanish",
  callbacks: :async,
  suggest: [:text],
  searchable: [:text]

  #scope :search_import, -> { includes([{city: :department}, {subcategory: :category}]) }

  def reindex_publication
    self.reindex # or reindex_async
  end

  def search_data
    {
      text: text
    }
  end

  def liked_by_user(user)
    user_consult_question_votes.where(user_id: user.id, points: 1).count > 0
  end

  def disliked_by_user(user)
    user_consult_question_votes.where(user_id: user.id, points: -1).count > 0
  end

  def self.recents
    order(created_at: :desc)
  end

  def self.hot
    order(points: :desc)
  end

  def self.by_categories(categories_id)
    includes(:consult_category).where({consult_categories: {id: categories_id}}).references(:consult_category)
  end

  def get_image
    if self.consult_question_images.count > 0
      self.consult_question_images.first.source.url
    else
      Information.first.meta_image.url
    end
  end
end
