json.positions @positions do |json, position|
  json.code position.code
  json.name position.name
  json.created_at position.created_at
  json.updated_at position.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @positions}