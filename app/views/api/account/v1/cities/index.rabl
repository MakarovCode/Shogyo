object @cities

attributes :id

node :name do |city|
  "#{city.name} - #{city.department.name}"
end
