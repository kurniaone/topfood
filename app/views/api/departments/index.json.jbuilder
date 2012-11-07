json.departments @departments do |json, department|
  json.code department.code
  json.name department.name
  json.created_at date_time_format(department.created_at, "%Y-%m-%d %H:%M:%S")
  json.updated_at date_time_format(department.updated_at, "%Y-%m-%d %H:%M:%S")
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @departments}