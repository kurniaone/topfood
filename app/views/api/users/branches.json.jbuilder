json.branches @branches do |json, branch|
  json.id branch.id
  json.name branch.name
  json.phone branch.phone
  json.address branch.address
  json.profile branch.profile
  json.center branch.center
  json.created_at date_time_format(branch.created_at, "%Y-%m-%d %H:%M:%S")
  json.updated_at date_time_format(branch.updated_at, "%Y-%m-%d %H:%M:%S")
end
