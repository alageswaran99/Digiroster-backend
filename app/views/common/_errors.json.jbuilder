if errors.present?
  errors.each_pair do |key, value|
    json.set! key, value
  end
end