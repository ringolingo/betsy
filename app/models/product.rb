class Product < ApplicationRecord
  belongs_to merchant
  #has_many :reviews, dependent: :destroy, :OrderItem
  validates :title, presence: true, uniqueness: true
end
