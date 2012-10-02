center = Branch.find_or_create_by_name(
  name: 'PT Toop Food Indonesia (Pusat)',
  center: true,
  phone: '123456',
  address: 'Tangerang'
)

User.find_or_create_by_email(
  email: 'su@topfood.com',
  password: 'Sutopf00d!!',
  password_confirmation: 'Sutopf00d!!',
  name: 'Superadmin',
  phone: '123456',
  address: 'Top Food Indonesia',
  su: true
)

User.find_or_create_by_email(
  email: 'admin@topfood.com',
  password: 'Admintopf00d!!',
  password_confirmation: 'Admintopf00d!!',
  name: 'Admin',
  phone: '123456',
  address: 'Top Food Indonesia',
  admin: true,
  branch_id: center.try(:id)
)
