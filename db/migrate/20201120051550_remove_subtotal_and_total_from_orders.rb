class RemoveSubtotalAndTotalFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column(:orders, :sub_total)
    remove_column(:orders, :order_total)
  end
end
