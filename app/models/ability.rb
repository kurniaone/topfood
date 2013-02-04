class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.su?
      can :manage, :all
    end

    # STORE MANAGER
    if user.role?('sm')
      can :read,    PurchaseOrder
      can :create,  PurchaseOrder
      can :update,  PurchaseOrder, no_approval: true
      can :destroy, PurchaseOrder, no_approval: true

      can :read,    WorkOrder
      can :create,  WorkOrder
      can :update,  WorkOrder, no_approval: true
      can :destroy, WorkOrder, no_approval: true

      can :read,    EmployeeOrder
      can :create,  EmployeeOrder
      can :update,  EmployeeOrder, no_approval: true
      can :destroy, WorkOrder, no_approval: true
    end

    # TEAM LEADER
    if user.role?('tl')
      can :read,    PurchaseOrder
      can :create,  PurchaseOrder
      can :update,  PurchaseOrder
      can :approve, PurchaseOrder
      can :destroy, PurchaseOrder, no_approval: true

      can :read,    WorkOrder
      can :create,  WorkOrder
      can :update,  WorkOrder
      can :approve, WorkOrder
      can :destroy, WorkOrder, no_approval: true

      can :read,    EmployeeOrder
      can :create,  EmployeeOrder
      can :update,  EmployeeOrder
      can :approve, EmployeeOrder
      can :destroy, EmployeeOrder, no_approval: true
    end

    # AST MANAGER
    if user.role?('asm')
      can :read,    PurchaseOrder
      can :create,  PurchaseOrder
      can :update,  PurchaseOrder
      can :approve, PurchaseOrder
      can :destroy, PurchaseOrder, no_approval: true

      can :read,    WorkOrder
      can :create,  WorkOrder
      can :update,  WorkOrder
      can :approve, WorkOrder
      can :destroy, WorkOrder, no_approval: true

      can :read,    EmployeeOrder
      can :create,  EmployeeOrder
      can :update,  EmployeeOrder
      can :approve, EmployeeOrder
      can :destroy, EmployeeOrder, no_approval: true
    end

    # MANAGER
    if user.role?('mng')
      can :read,    PurchaseOrder
      can :create,  PurchaseOrder
      can :update,  PurchaseOrder
      can :approve, PurchaseOrder
      can :destroy, PurchaseOrder, no_approval: true

      can :read,    WorkOrder
      can :create,  WorkOrder
      can :update,  WorkOrder
      can :approve, WorkOrder
      can :destroy, WorkOrder, no_approval: true

      can :read,    EmployeeOrder
      can :create,  EmployeeOrder
      can :update,  EmployeeOrder
      can :approve, EmployeeOrder
      can :destroy, EmployeeOrder, no_approval: true
    end

    # GENERAL MANAGER
    if user.role?('gm')
      can :read,    PurchaseOrder
      can :create,  PurchaseOrder
      can :update,  PurchaseOrder
      can :approve, PurchaseOrder
      can :destroy, PurchaseOrder, no_approval: true

      can :read,    WorkOrder
      can :create,  WorkOrder
      can :update,  WorkOrder
      can :approve, WorkOrder
      can :destroy, WorkOrder, no_approval: true

      can :read,    EmployeeOrder
      can :create,  EmployeeOrder
      can :update,  EmployeeOrder
      can :approve, EmployeeOrder
      can :destroy, EmployeeOrder, no_approval: true
    end

    # PURCHASING
    if user.role?('pch')
      can :read,      PurchaseOrder
      can :received,  PurchaseOrder
      can :done,      PurchaseOrder
    end

    # MAINTENANCE
    if user.role?('mnt')
      can :read,      WorkOrder
      can :received,  WorkOrder
      can :done,      WorkOrder
    end

    # HRD
    if user.role?('hrd')
      can :read,      EmployeeOrder
      can :received,  EmployeeOrder
      can :done,      EmployeeOrder
    end

  end
end
