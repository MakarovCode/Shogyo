object @user

attributes :id, :email, :phone, :address

node :likes do |user|
  user.likes
end

node :dislikes do |user|
  user.dislikes
end

node :name do |user|
  unless user.name.nil?
    user.name
  else
    "Sin información"
  end
end

node :main_activity do |user|
  unless user.main_activity.blank?
    user.main_activity
  else
    "Sin información"
  end
end

node :image do |user|
  user.get_profile_image
end

node :message do |user|
  "Info user"
end

node :profession do |user|
  unless user.profession.nil?
    user.profession
  else
    "Sin información"
  end
end

node :location do |user|
  unless user.country.nil?
    user.country.name
  else
    "Sin información"
  end
end

node :phone do |user|
  unless user.phone.nil?
    user.phone
  else
    ""
  end
end

node :birthdate do |user|
  unless user.birthdate.nil?
    user.birthdate.strftime("%Y-%m-%d")
  else
    ""
  end
end

node :gender do |user|
  unless user.gender.nil?
    user.gender
  else
    ""
  end
end

node :confirmed do |user|
  user.confirmed?
end

node :completed do |user|
  user.completed?
end

node :percent do |user|
  user.get_profile_percent
end

child :interests do
  attributes :id, :name
end

node :city do |user|
  unless user.city.nil?
    partial("api/account/v1/cities/index", object: user.city)
  else
    ""
  end
end
