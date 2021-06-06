class Interest < ApplicationRecord
  has_many :interest_categories
  has_many :categories, through: :interest_categories 
end
