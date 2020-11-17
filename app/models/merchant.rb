class Merchant < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  # has_many :products, dependent: :destroy
  # has_one_attached :icon
end
