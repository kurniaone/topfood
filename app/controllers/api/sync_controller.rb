class Api::SyncController < ApiController
  before_filter :require_app_id

  def index
    apps_orders = AppsOrder.where("app_id = ?", app_id)
    @orders = apps_orders.blank? ? Order.all : Order.to_sync(app_id)
    @orders = @orders.paginate(page: params[:page])

    unless @orders.blank?
      AppsOrder.update_app_timestamp(app_id, @orders)

      respond_with @orders
    else
      render json: { message: "Already up to date." }
    end
  end
end
