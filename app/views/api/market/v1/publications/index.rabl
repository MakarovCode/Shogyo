object @publications

attributes :id, :title, :slug, :visits_count, :subject, :user_id

node :description do |publication|
  Nokogiri::HTML(publication.description).text
end

node :image do |publication|
  publication.get_image("mid")
end

node :user do |publication|
  partial("api/account/v1/users/show", object: publication.user)
end


node :price do |publication|
  unless publication.in_need == true
    number_to_currency publication.price, precision: 0
  else
    "$0"
  end
end

node :in_need do |publication|
  if publication.in_need == true
    true
  else
    false
  end
end

node :for_adoption do |publication|
  if publication.for_adoption == true
    true
  else
    false
  end
end

node :to_agree do |publication|
  if publication.to_agree == true
    true
  else
    false
  end
end

node :kind do |publication|
  if publication.subject == Publication::INMUEBLES
    "#{publication.get_kind} - #{publication.get_mode}"
  else
    publication.get_kind
  end
end

node :is_official do |publication|
  if publication.user.is_official == true
    true
  else
    false
  end
end

node :city do |publication|
  unless publication.city.blank?
    "#{publication.city.name} - #{publication.city.department.name}"
  end
end

node :category do |publication|
  "#{publication.subcategory.category.name} - #{publication.subcategory.name}"
end

node :date do |publication|
  publication.created_at.strftime("%b %d")
end
