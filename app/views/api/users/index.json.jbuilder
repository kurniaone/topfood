json.users @users do |json, user|
  json.id user.id
  json.email user.email
  json.name user.name
  json.phone user.phone
  json.address user.address
  json.role user.role.name
  json.created_at date_time_format(user.created_at, "%Y-%m-%d %H:%M:%S")
  json.updated_at date_time_format(user.updated_at, "%Y-%m-%d %H:%M:%S")
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @users}