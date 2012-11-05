json.units @units do |json, unit|
  json.code unit.code
  json.name unit.name
  json.created_at unit.created_at
  json.updated_at unit.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @units}