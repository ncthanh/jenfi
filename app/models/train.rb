class Train < ApplicationRecord
  include AASM
  include EventHelper

  aasm do
    state :standby, initial: true
    state :withdrawn

    state :booked
    state :departed
    state :arrived

    event :book do
      before do |charging_method:|
        Parcel.where(id: self.estimate_parcel_ids).find_each do |parcel|
          parcel.ship!(
            self.id,
            self.total_cost * (charging_method.by_weight? ? parcel.weight / self.estimate_weight : parcel.volume / self.estimate_volume),
          )
        end
      end

      transitions from: :standby, to: :booked,
        success: proc { fire_later(:depart) }
    end

    event :depart do
      before do
        self.depart_track = self.tracks.unoccupied.last
        self.depart_at = Time.now
        self.save!
      end

      transitions from: :booked, to: :departed,
        success: proc {
          self.depart_track.occupy_by_train!
          fire_later(:arrive, wait: DEFAULT_RUN_TIME)
        }
    end

    event :arrive do
      transitions from: :departed, to: :arrived,
        success: proc {
          self.depart_track.clear_train!
        }
    end

    event :withdraw do
      transitions from: :standby, to: :withdrawn
    end
  end

  DEFAULT_RUN_TIME = 3.minutes

  belongs_to :train_operator
  belongs_to :depart_track, class_name: "Track", optional: true
  has_and_belongs_to_many :tracks
  has_many :parcels

  validates_presence_of :train_no, :total_cost, :total_weight, :total_volume, :tracks

  attr_accessor :estimate_weight, :estimate_volume, :parcel_to_compare, :estimate_parcel_ids

  def has_capacity_for?(parcel)
    @estimate_weight ||= 0
    @estimate_volume ||= 0

    parcel.weight + @estimate_weight <= total_weight && parcel.volume + @estimate_volume <= total_volume
  end

  def add(parcel)
    @estimate_weight += parcel.weight
    @estimate_volume += parcel.volume
    @parcel_to_compare ||= parcel
    @estimate_parcel_ids ||= []
    @estimate_parcel_ids << parcel.id
  end
end
