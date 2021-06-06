class PostSubcategory < ApplicationRecord
  belongs_to :post
  belongs_to :subcategory
end
