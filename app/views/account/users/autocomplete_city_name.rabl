object @cities

attributes :id

node :value do |city|
  "#{city.name} - #{city.department.name}"
end

node :label do |city|
  "#{city.name} - #{city.department.name}"
end
