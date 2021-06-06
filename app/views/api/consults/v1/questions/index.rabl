object @questions

attributes :id, :points, :visits_count, :text

node :message do |question|
  question.text
end

node :image do |question|
  if question.consult_question_images.count > 0
    question.consult_question_images.first.source.mid.url
  else
    "none"
  end
end

node :image_full do |question|
  if question.consult_question_images.count > 0
    question.consult_question_images.first.source.high.url
  else
    "none"
  end
end

node :user do |question|
  partial("api/account/v1/users/show", object: question.user)
end

node :date do |question|
  question.created_at.strftime("%b %d")
end

node :likes do |question|
  question.user_consult_question_votes.positives.count
end

node :dislikes do |question|
  question.user_consult_question_votes.negatives.count
end

node :liked do |question|
  unless (defined? current_user).nil?
    question.liked_by_user current_user
  else
    false
  end
end

node :disliked do |question|
  unless (defined? current_user).nil?
    question.disliked_by_user current_user
  else
    false
  end
end

child :consult_category do
  attributes :id, :name
end

node :answers do |question|
  question.answers.map { |a| partial("api/consults/v1/answers/index", object: a)   }
end
