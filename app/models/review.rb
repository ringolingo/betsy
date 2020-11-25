class Review < ApplicationRecord

  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 6}
  validates :description, presence: true
  belongs_to :product
end
