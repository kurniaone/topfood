json.roles @roles do |json, role|
  json.code role.code
  json.name role.name
  json.description role.description
  json.created_at role.created_at
  json.updated_at role.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @roles}