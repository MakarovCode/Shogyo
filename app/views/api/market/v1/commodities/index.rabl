object @commodities

attributes :id, :name

node :message do |commodity|
  "Mensaje"
end

node :last_value do |commodity|
  unless commodity.variations.first.nil?
    "#{commodity.variations.first.value} #{commodity.variations.first.currency}"
  else
    "Sin información"
  end
end

node :last_status do |commodity|
  unless commodity.variations.first.nil?
    commodity.variations.first.status
  else
    0
  end
end

node :variations, if: lambda { |s| @full_data == true } do |commodity|
  partial("api/market/v1/commodities/variations", object: @variations)
end
