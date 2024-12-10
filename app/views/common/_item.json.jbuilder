if item.present?
  item.each_pair do |key, value|
    json.set! key, value
  end
end