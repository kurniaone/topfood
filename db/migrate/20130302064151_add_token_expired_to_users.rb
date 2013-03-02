class AddTokenExpiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_expired, :datetime
  end
end
