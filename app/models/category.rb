class Category < ApplicationRecord
  validates :category, presence: true, uniqueness: true

  has_and_belongs_to_many :products
end
