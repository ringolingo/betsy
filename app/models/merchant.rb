class Merchant < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  has_many :products, dependent: :destroy
  has_and_belongs_to_many :orders
  has_one_attached :icon

  def filter_order(order)
    merchant_items = []

    order.order_items.each do |item|
      if item.product.merchant == self
        merchant_items << item
      end
    end

    return merchant_items
  end
end
