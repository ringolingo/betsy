class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :orderitem
  validates :name, presence: true, uniqueness: true
end
