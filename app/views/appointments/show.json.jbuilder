if @errors.present?
  json.partial! 'common/errors', locals: { errors: @errors }
else
  json.partial! 'common/item', locals: { item: @item }
end