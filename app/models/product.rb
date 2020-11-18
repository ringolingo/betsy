class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items
  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  validates :description, presence: true
  validates :price , presence: true, numericality: { greater_than: 0, message: "Price must be greater than 0"}
  # validates :photo_url, presence: true ** figure out how to validate image links
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, message: "Stock cannot be below 0"}

  def self.category
    return ['bedding', 'sleep aids', 'pajamas', 'night lights']
  end
end

