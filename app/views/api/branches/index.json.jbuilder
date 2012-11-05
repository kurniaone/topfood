json.branches @branches do |json, branch|
  json.id branch.id
  json.name branch.name
  json.phone branch.phone
  json.address branch.address
  json.profile branch.profile
  json.center branch.center
  json.created_at branch.created_at
  json.updated_at branch.updated_at
end

json.partial! :partial => "/layouts/json_paginate.json.jbuilder", :locals => {:objects => @branches}