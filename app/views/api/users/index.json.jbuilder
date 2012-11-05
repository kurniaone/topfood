json.users @users do |json, user|
  json.id user.id
  json.email user.email
  json.name user.name
  json.phone user.phone
  json.address user.address
  json.role user.role.name
  json.created_at user.created_at
  json.updated_at user.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @users}