class AppsOrder < ActiveRecord::Base
  belongs_to :order

  attr_accessible :app_id, :order_id, :order_timestamp, :app_timestamp

# CALLBACK

# CLASS METHOD
  def self.app_ids
    select(:app_id).uniq.map(&:app_id)
  end

  def self.update_app_timestamp(app_id, orders = [])
    apps_orders = where("app_id = ?", app_id)
    if apps_orders.blank?
      attrs = []
      orders.each do |order|
        attrs << {
          app_id: app_id,
          order_id: order.id,
          order_timestamp: order.updated_at,
          app_timestamp: order.updated_at
        }
      end

      create(attrs)
    else
      update_all(["app_timestamp = order_timestamp"], ["app_id = ? AND order_id IN (?)", app_id, orders.map(&:id)])
    end
  end


# INSTANCE METHOD

end
