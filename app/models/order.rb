class Order < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :merchants
  has_many :products, through: :order_items
  validates :status, presence: true, inclusion: { in: %w(pending paid),
               message: "%{value} is not a valid status" }

  def check_stock
    result = []

    self.order_items.each do |item|

      if item.quantity > item.product.stock
        result << [item.product.name, item.product.stock]
      end
    end
    return result
  end

  def decrement_stock
    self.order_items.each do |item|
      item.product.stock -= item.quantity
      item.product.save
    end
  end

  def total(tax:, shipping:)
    return sub_total + (sub_total * tax).round + shipping
  end

  def sub_total
    return self.order_items.all.sum{|order_item| (order_item.quantity * order_item.product.price)}
  end
end
