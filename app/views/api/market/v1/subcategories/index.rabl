object @subcategories

attributes :id

node :label do |subcategory|
  label = "#{subcategory.name.camelcase} "
  if subcategory.synonims != "" && !subcategory.synonims.nil?
    label += "(#{subcategory.synonims.camelcase})"
  end
end

node :value do |subcategory|
  subcategory.name
end
