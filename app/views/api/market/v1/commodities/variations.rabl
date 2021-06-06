object @variations

attributes :id, :value, :currency, :status

node :date do |variation|
  variation.created_at.strftime("%Y-%m-%d")
end
