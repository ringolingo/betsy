class Order < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :merchants
  has_many :products, through: :order_items
  validates :status, presence: true, inclusion: { in: %w(pending paid),
               message: "%{value} is not a valid status" }

  def return_merchants
    merchants = []
    self.order_items.each do |current_item|
      merchants << Merchant.find_by(id: current_item.product.merchant_id)
    end
    return merchants.any? ? merchants.uniq : merchants
  end

  def return_merchant_items(current_merchant_id)
    merchant_items = []
    if self.order_items.any?
      self.order_items.each do |current_item|
        if current_item.product.merchant.id == current_merchant_id
          merchant_items << current_item
        end
      end
    end
    return merchant_items
  end

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
end
