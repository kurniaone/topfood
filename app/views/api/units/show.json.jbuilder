json.code @unit.code
json.name @unit.name
json.created_at date_time_format(@unit.created_at, "%Y-%m-%d %H:%M:%S")
json.updated_at date_time_format(@unit.updated_at, "%Y-%m-%d %H:%M:%S")