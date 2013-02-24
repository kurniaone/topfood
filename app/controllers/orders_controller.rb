class OrdersController < ApplicationController

  def approve
    approval = Approval.find_by_id(params[:id])
    @order = approval.order

    if approval.update_attributes(approved: approved?, reason: params[:reason]) && @order.update_attributes(updated_by: 'server')
      @order.send_email_to_approver(purchase_order_url(@order)) if approved?
      flash[:notice] = "Order is #{approved? ? 'Approved' : 'Rejected'}"
    else
      flash[:alert] = approval.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

  def received
    authorize! :received, @order
    if @order.update_attributes(implement_status: 'received')
      flash[:notice] = "Order is already marked as received"
    else
      flash[:notice] = @order.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

  def done
    authorize! :done, @order
    if @order.update_attributes(implement_status: 'done')
      flash[:notice] = "Order is already marked as done"
    else
      flash[:notice] = @order.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

end
