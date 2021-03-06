class Merchant < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: {scope: :provider}
  validate :acceptable_avatar, on: :update

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.byte_size <= 1.megabyte
      errors.add(:avatar, "must be under 1MB")
    end

    acceptable_types = ["image/png", "image/jpeg"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:avatar, "must be a JPEG or PNG")
    end
  end

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash["uid"]
    merchant.provider = auth_hash["provider"]
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the user has not been saved.
    # We will chose to do the saving outside of this
    return merchant
  end

  has_many :products, dependent: :destroy
  has_and_belongs_to_many :orders
  has_one_attached :avatar

  def filter_order(order)
    merchant_items = []

    order.order_items.each do |item|
      if item.product.merchant == self
        merchant_items << item
      end
    end

    return nil if merchant_items.empty?
    return merchant_items
  end

  def total_revenue(status = "all")
    return 0 if self.orders.empty?

    requested_orders = Order.select_status(status: status, merchant: self)
    return 0 if requested_orders.empty?

    all_items = []
    requested_orders.each do |order|
      order_items = self.filter_order(order)
      all_items += order_items unless order_items.nil?
    end

    return all_items.sum { |item| item.line_item_total }
  end

  def sort_products
    products = []

    active = Product.where(for_sale: true, merchant: self).order(created_at: :desc)
    products << active

    retired = Product.where(for_sale: false, merchant: self).order(created_at: :desc)
    products << retired

    return nil if products.flatten.empty?
    return products.flatten
  end
end
