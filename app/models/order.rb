class Order < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :merchants
  has_many :products, through: :order_items
  validates :status, presence: true, inclusion: { in: %w(pending paid),
               message: "%{value} is not a valid status" }
  validates :name, presence: true, if: :paid?
  validates :address, presence: true, if: :paid?
  validates :email, presence: true, if: :paid?
  validates :expiration_date, presence: true, if: :paid?
  validates :cvv, presence: true, numericality: { only_integer: true, greater_than: 99, less_than: 10000, message: "CVV is incorrectly formatted"}, if: :paid?
  validates :zip_code, presence: true, numericality: { only_integer: true, less_than: 99951,message: "Zip Code is incorrectly formatted"}, if: :paid?
  validates :credit_card_number, presence: true, numericality: { only_integer: true, greater_than: 99999999999999, less_than: 10000000000000000,message: "Credit card number is incorrectly formatted"}, if: :paid?

  def paid?
    status == "paid"
  end

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

  def total(tax:, shipping:)
    return 0 if sub_total == 0
    return sub_total + (sub_total * tax).round + shipping
  end

  def sub_total
    return self.order_items.all.sum{|order_item| (order_item.quantity * order_item.product.price)}
  end
end
