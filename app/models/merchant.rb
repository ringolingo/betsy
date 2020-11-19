class Merchant < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: {scope: :provider}
  validates :username, presence: true

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
  has_one_attached :icon

end
