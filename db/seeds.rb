puts "Top Food Center ..."
center = Branch.find_or_create_by_name(
  center: true,
  name: 'PT Toop Food Indonesia (Pusat)',
  phone: '123456',
  address: 'Tangerang'
)

puts "User ..."
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
  email: 'sm@topfood.com',
  password: 'Branchtopf00d!!',
  password_confirmation: 'Branchtopf00d!!',
  name: 'Store Manager',
  phone: '123456',
  address: 'Top Food Indonesia'
)

puts "Approval Setting ..."
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'PurchaseOrder', center: true)
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'PurchaseOrder', center: false)
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'WorkOrder', center: true)
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'WorkOrder', center: false)
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'EmployeeOrder', center: true)
ApprovalSetting.find_or_create_by_order_class_and_center(order_class: 'EmployeeOrder', center: false)

puts "Department ..."
Department.find_or_create_by_name(code: 'hrd', name: 'HRD')
Department.find_or_create_by_name(code: 'pch', name: 'Purchasing')
Department.find_or_create_by_name(code: 'ga', name: 'General Affair')
Department.find_or_create_by_name(code: 'pro', name: 'Production')
Department.find_or_create_by_name(code: 'eng', name: 'Engineering')

puts "Position ..."
Position.find_or_create_by_name(code: 'SM', name: 'Store Manager')
Position.find_or_create_by_name(code: 'KA', name: 'Kepala Bagian')
Position.find_or_create_by_name(code: 'KASUB', name: 'Kepala Sub Bagian')
Position.find_or_create_by_name(code: 'STAFF', name: 'Staff')
Position.find_or_create_by_name(code: 'OB', name: 'Office Boy')

puts "Unit ..."
Unit.find_or_create_by_name(code: 'kg', name: 'Kilo Gram')
Unit.find_or_create_by_name(code: 'g', name: 'Gram')
Unit.find_or_create_by_name(code: 'm', name: 'Meter')
Unit.find_or_create_by_name(code: 'pieces', name: 'Pieces')
Unit.find_or_create_by_name(code: 'roll', name: 'Roll')
Unit.find_or_create_by_name(code: 'set', name: 'Set')
Unit.find_or_create_by_name(code: 'pack', name: 'Pack')
Unit.find_or_create_by_name(code: 'dus', name: 'Dus')
Unit.find_or_create_by_name(code: 'lusin', name: 'Lusin')
Unit.find_or_create_by_name(code: 'kodi', name: 'Kodi')
Unit.find_or_create_by_name(code: 'rim', name: 'Rim')
Unit.find_or_create_by_name(code: 'gross', name: 'Gross')
Unit.find_or_create_by_name(code: 'l', name: 'Liter')

puts "Role ..."
Role.find_or_create_by_name(code: 'GM', name: 'General Manager')
Role.find_or_create_by_name(code: 'MNG', name: 'Manager')
Role.find_or_create_by_name(code: 'AM', name: 'Assistant Manager')
Role.find_or_create_by_name(code: 'TL', name: 'Team Leader')
Role.find_or_create_by_name(code: 'SM', name: 'Store Manager')
Role.find_or_create_by_name(code: 'GA', name: 'General Affair')
Role.find_or_create_by_name(code: 'HRD', name: 'HRD')
Role.find_or_create_by_name(code: 'PCH', name: 'Purchasing')

