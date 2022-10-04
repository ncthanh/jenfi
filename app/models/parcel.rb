class Parcel < ApplicationRecord
  include AASM

  aasm do
    state :created, initial: true
    state :withdrawn
    state :shipped

    event :ship do
      before do |train_id, shipping_cost|
        self.train_id = train_id
        self.shipping_cost = shipping_cost
        self.save!
      end

      transitions from: :created, to: :shipped
    end

    event :withdraw do
      transitions from: :created, to: :withdrawn
    end
  end

  belongs_to :parcel_owner
  belongs_to :train, optional: true

  validates_presence_of :weight, :volume
end
