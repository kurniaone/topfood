json.positions @positions do |json, position|
  json.id   position.id
  json.code position.code
  json.name position.name
  json.created_at date_time_format(position.created_at, "%Y-%m-%d %H:%M:%S")
  json.updated_at date_time_format(position.updated_at, "%Y-%m-%d %H:%M:%S")
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @positions}
