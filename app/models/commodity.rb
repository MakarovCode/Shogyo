class Commodity < ApplicationRecord
  has_many :variations, -> { order(created_at: :desc) }
end
