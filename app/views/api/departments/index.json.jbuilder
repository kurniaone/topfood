json.departments @departments do |json, department|
  json.code department.code
  json.name department.name
  json.created_at department.created_at
  json.updated_at department.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @departments}