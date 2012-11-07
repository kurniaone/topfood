json.code @department.code
json.name @department.name
json.created_at date_time_format(@department.created_at, "%Y-%m-%d %H:%M:%S")
json.updated_at date_time_format(@department.updated_at, "%Y-%m-%d %H:%M:%S")