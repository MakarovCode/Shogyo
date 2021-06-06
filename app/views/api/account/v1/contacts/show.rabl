object @contacts

attributes :id, :message

node :created_at do |contact|
  contact.created_at.strftime("%b %d a las %H:%M")
end

node :interested do |contact|
  partial("api/account/v1/users/show", object: contact.interested)
end

node :user do |contact|
  partial("api/account/v1/users/show", object: contact.user)
end
