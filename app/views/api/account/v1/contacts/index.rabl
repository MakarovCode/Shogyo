object @conversations

attributes :id, :message

node :user do |contact|
  partial("api/account/v1/users/show", object: contact.interested)
end
