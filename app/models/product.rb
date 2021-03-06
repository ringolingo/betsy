class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :categories
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price , presence: true, numericality: { greater_than: 0, message: "Price must be greater than 0"}
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, message: "Stock cannot be below 0"}
  validates :for_sale, inclusion: { in: [true, false] }

  def self.by_category(id)
    all_products = Product.all.where(active: true)
    category_products = []

    all_products.each do |product|
      if product.categories.find_by(id: id)
        category_products << product
      end
    end
    return category_products
  end

  def toggle_for_sale
    self.for_sale = !self.for_sale
    
    self.save
  end

  def avg_rating
    reviews = self.reviews
    if reviews.count > 0
      total = reviews.reduce(0) { |sum, review| sum + review.rating }
      avg = total/reviews.count

      return avg
    else
      return 0
    end
  end
end

