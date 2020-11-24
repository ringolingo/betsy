class AddDefaultValueToOrderItemsShipped < ActiveRecord::Migration[6.0]
  def change
    change_column :order_items, :shipped, :boolean, :default => false
  end
end
