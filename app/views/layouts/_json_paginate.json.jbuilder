if objects.present? && objects.class != Array
  json.current_page objects.current_page
  json.per_page objects.per_page
  json.total_entries objects.total_entries
else
  json.pagination "none"
end