class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :shipped, inclusion: { in: [true, false] }

  def self.arrange_by_created_at
    return OrderItem.order(created_at: :asc)
  end

  def mark_as_shipped
    return nil unless self.order.status == "paid"

    self.shipped = true
    self.save
  end

  def line_item_total
    return 0 if self.quantity == 0

    return (self.quantity * self.product.price)
  end
end
