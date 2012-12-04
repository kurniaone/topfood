json.user_name @approval.user_name || approval.user.try(:name)
json.email @approval.user.try(:email)
json.approved @approval.approved
json.at @approval.do_at