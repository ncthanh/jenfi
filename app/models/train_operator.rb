class TrainOperator < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :trains, dependent: :destroy
end
