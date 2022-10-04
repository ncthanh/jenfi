class ParcelOwner < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :parcels, dependent: :destroy
end
