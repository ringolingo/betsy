class Order < ApplicationRecord
  has_many :order_items
  has_and_belongs_to_many :merchants
  validates :status, presence: true, inclusion: { in: %w(pending paid),
               message: "%{value} is not a valid status" }
end
