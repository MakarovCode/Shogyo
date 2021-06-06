object @answer

attributes :id, :points, :text

node :message do |answer|
  "Respuesta"
end

node :image do |answer|
  if answer.consult_answer_images.count > 0
    answer.consult_answer_images.first.source.mid.url
  else
    "none"
  end
end

node :image_full do |answer|
  if answer.consult_answer_images.count > 0
    answer.consult_answer_images.first.source.high.url
  else
    "none"
  end
end

node :user do |answer|
  partial("api/account/v1/users/show", object: answer.user)
end

node :date do |answer|
  answer.created_at.strftime("%b %d")
end

node :likes do |answer|
  answer.user_consult_answer_votes.positives.count
end

node :dislikes do |answer|
  answer.user_consult_answer_votes.negatives.count
end

node :liked do |answer|
  unless (defined? current_user).nil?
    answer.liked_by_user current_user
  else
    false
  end
end

node :disliked do |answer|
  unless (defined? current_user).nil?
    answer.disliked_by_user current_user
  else
    false
  end
end
