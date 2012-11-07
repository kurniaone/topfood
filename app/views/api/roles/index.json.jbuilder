json.roles @roles do |json, role|
  json.code role.code
  json.name role.name
  json.description role.description
  json.created_at date_time_format(role.created_at, "%Y-%m-%d %H:%M:%S")
  json.updated_at date_time_format(role.updated_at, "%Y-%m-%d %H:%M:%S")
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @roles}