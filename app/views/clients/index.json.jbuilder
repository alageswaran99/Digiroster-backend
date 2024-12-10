if @errors.present?
  json.partial! 'common/errors', locals: { errors: @errors }
else
  json.set! :clients do
    json.array! @items do |item|
      json.partial! 'common/item', locals: { item: item }
    end
  end

  if @meta
    json.set! :meta do
      @meta.each_pair do |key, value|
        json.set! key, value
      end
    end
  end
end