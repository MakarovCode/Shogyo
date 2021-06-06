object @posts

attributes :id, :title, :abstract, :content, :is_news

node :slug do |post|
  if post.slug.nil? || post.slug == ""
    post.id
  else
    post.slug
  end
end

node :image_wide do |post|
  post.image.wide.url
end

node :image_high do |post|
  post.image.high.url
end

node :image do |post|
  post.image.mid.url
end

node :video do |post|
  unless post.video.nil?
    post.video
  else
    "none"
  end
end

node :date do |post|
  post.date.strftime("%b %d")
end

child :tags do
  attributes :id, :name
end

node :category_name do |post|
   if post.subcategories.count > 0
     post.subcategories.first.category.name
   else
     "#0F6A37"
   end
end

node :color do |post|
   if post.subcategories.count > 0
     post.subcategories.first.category.hex_color
   else
     "#0F6A37"
   end
end

node :location do |post|
  post.get_scope
end

child :subcategories do
  attributes :id, :name

  child :category do
    attributes :id, :name
  end
end
