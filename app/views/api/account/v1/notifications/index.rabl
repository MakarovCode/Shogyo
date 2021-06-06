object @notifications

attributes :id, :text, :object_id, :object_type

node :image do |notification|
  notification.get_image
end

node :created_at do |notification|
  distance_of_time_in_words notification.created_at, Time.now
end
