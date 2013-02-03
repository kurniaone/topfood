class AppMailer < ActionMailer::Base
  default from: "system@topfood.com"

  def send_notification_to_approver(order, approver, order_url)
    get_data(order, approver)
    @url = order_url
    mail(
      to:       @approver.email,
      subject:  "[Topfood] #{@order.type} has been created ##{@order.order_number}"
    )
  end

  def send_notification_to_implementer(order)
    @order        = Order.find_by_id order["id"]
    @implementer  = User.find_by_role_code Order::Implementer.const_get(@order.type.underscore.upcase)
    mail(
      to:         @implementer.email,
      subject:    "[Topfood] #{@order.type} has been approved ##{@order.order_number}"
    )
  end

  protected
    def get_data(order, approver)
      @order = Order.find_by_id order["id"]
      @approver = User.find_by_id approver["id"]
    end
end
