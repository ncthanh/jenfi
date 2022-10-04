class Track < ApplicationRecord
  include AASM

  aasm do
    state :unoccupied, initial: true
    state :occupied

    event :occupy_by_train do
      transitions from: :unoccupied, to: :occupied
    end

    event :clear_train do
      transitions from: :occupied, to: :unoccupied
    end
  end

  has_and_belongs_to_many :trains

  validates :track_no, presence: true, uniqueness: true
end
