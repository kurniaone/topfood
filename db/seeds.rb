branch = Branch.find_or_create_by_name(
  center: true,
  name: 'PT Toop Food Indonesia (Pusat)',
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
  branch_id: branch.try(:id)
)

ApprovalSetting.find_or_create_by_order_class(order_class: 'PurchaseOrder')
ApprovalSetting.find_or_create_by_order_class(order_class: 'WorkOrder')
ApprovalSetting.find_or_create_by_order_class(order_class: 'EmployeeOrder')

Department.find_or_create_by_name(code: 'hrd', name: 'HRD')
Department.find_or_create_by_name(code: 'pch', name: 'Purchasing')
Department.find_or_create_by_name(code: 'ga', name: 'General Afair')

Management.find_or_create_by_name(code: 'GM', name: 'General Manager', level: 1)
Management.find_or_create_by_name(code: 'MNG', name: 'Manager', level: 2)
Management.find_or_create_by_name(code: 'AM', name: 'Assistant Manager', level: 2.1)
Management.find_or_create_by_name(code: 'TL', name: 'Team Leader', level: 3)
Management.find_or_create_by_name(code: 'SM', name: 'Store Manager', level: 4)

Position.find_or_create_by_name(name: 'KA', name: 'Kepala Bagian')
Position.find_or_create_by_name(name: 'KASUB', name: 'Kepala Sub Bagian')
Position.find_or_create_by_name(name: 'STAFF', name: 'Staff')
