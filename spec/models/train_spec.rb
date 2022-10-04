require "rails_helper"

RSpec.describe Train, type: :model do
  describe "#book" do
    let(:by_weight) { ActiveSupport::StringInquirer.new("by_weight") }
    let(:by_volume) { ActiveSupport::StringInquirer.new("by_volume") }
    let(:parcel_1) { create(:parcel) }
    let(:parcel_2) { create(:parcel) }
    let(:sum_weight) { parcel_1.weight + parcel_2.weight }
    let(:sum_volume) { parcel_1.volume + parcel_2.volume }

    it "populates shipping details for parcels based on weight" do
      train = create(:train)
      allow(train).to receive(:estimate_parcel_ids).and_return([parcel_1.id, parcel_2.id])
      allow(train).to receive(:estimate_weight).and_return(sum_weight)

      expect do
        train.book!(charging_method: by_weight)
      end.to change { train.aasm_state }.from("standby").to("booked")

      parcel_1.reload
      parcel_2.reload

      expect(parcel_1.aasm_state).to eq("shipped")
      expect(parcel_1.shipping_cost).to eq((train.total_cost * parcel_1.weight / sum_weight).round(2))

      expect(parcel_2.aasm_state).to eq("shipped")
      expect(parcel_2.shipping_cost).to eq((train.total_cost * parcel_2.weight / sum_weight).round(2))
    end

    it "populates shipping details for parcels based on volume" do
      train = create(:train)
      allow(train).to receive(:estimate_parcel_ids).and_return([parcel_1.id, parcel_2.id])
      allow(train).to receive(:estimate_volume).and_return(sum_volume)

      expect do
        train.book!(charging_method: by_volume)
      end.to change { train.aasm_state }.from("standby").to("booked")

      parcel_1.reload
      parcel_2.reload

      expect(parcel_1.aasm_state).to eq("shipped")
      expect(parcel_1.shipping_cost).to eq((train.total_cost * parcel_1.volume / sum_volume).round(2))

      expect(parcel_2.aasm_state).to eq("shipped")
      expect(parcel_2.shipping_cost).to eq((train.total_cost * parcel_2.volume / sum_volume).round(2))
    end
  end

  describe "#depart" do
    it "saves departing details" do
      train = create(:train, aasm_state: "booked")
      expect do
        train.depart!
      end.to change { train.aasm_state }.from("booked").to("departed")
        .and change { train.depart_track }.from(nil).to(train.tracks.last)
    end

    it "changes the track to occupied" do
      train = create(:train, aasm_state: "booked")
      track = train.tracks.first

      expect do
        train.depart!
      end.to change { track.reload.aasm_state }.from("unoccupied").to("occupied")
    end
  end

  describe "#arrive" do
    it "clears the track to make it unoccupied" do
      depart_track = create(:track, aasm_state: "occupied")
      train = create(:train, aasm_state: "departed", depart_track: depart_track)

      expect do
        train.arrive!
      end.to change { train.reload.aasm_state }.from("departed").to("arrived")
        .and change { depart_track.reload.aasm_state }.from("occupied").to("unoccupied")
    end
  end

  describe "Estimate Shipping Limit" do
    it "checks if a parcel can be added" do
      train = create(:train, total_weight: 100, total_volume: 1_000)
      train.instance_variable_set(:@estimate_weight, 90)
      train.instance_variable_set(:@estimate_volume, 900)

      parcel_1 = create(:parcel, weight: 5, volume: 150)
      expect(train.has_capacity_for?(parcel_1)).to be false

      parcel_2 = create(:parcel, weight: 20, volume: 5)
      expect(train.has_capacity_for?(parcel_2)).to be false

      parcel_3 = create(:parcel, weight: 2, volume: 5)
      expect(train.has_capacity_for?(parcel_3)).to be true
    end

    it "adds a parcel" do
      train = create(:train)
      train.instance_variable_set(:@estimate_weight, 90)
      train.instance_variable_set(:@estimate_volume, 900)

      parcel = create(:parcel, weight: 5, volume: 150)
      train.add(parcel)

      expect(train.instance_variable_get(:@estimate_weight)).to eq(95)
      expect(train.instance_variable_get(:@estimate_volume)).to eq(1050)
      expect(train.instance_variable_get(:@parcel_to_compare)).to eq(parcel)
      expect(train.instance_variable_get(:@estimate_parcel_ids)).to eq([parcel.id])
    end
  end

  describe "Validations" do
    let(:track) { create(:track) }
    let(:operator) { create(:train_operator) }

    it "is valid with valid attributes" do
      parcel = described_class.new(train_operator: operator, train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: 8_000_000, tracks: [track])
      expect(parcel).to be_valid
    end

    it "is not valid without a train_operator" do
      parcel = described_class.new(train_operator: nil, train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: 8_000_000, tracks: [track])
      expect(parcel).not_to be_valid
    end

    it "is not valid without a train_no" do
      parcel = described_class.new(train_operator: operator, train_no: nil, total_cost: 200, total_weight: 500, total_volume: 8_000_000, tracks: [track])
      expect(parcel).not_to be_valid
    end

    it "is not valid without a total_cost" do
      parcel = described_class.new(train_operator: operator, train_no: "Thomas", total_cost: nil, total_weight: 500, total_volume: 8_000_000, tracks: [track])
      expect(parcel).not_to be_valid
    end

    it "is not valid without a total_weight" do
      parcel = described_class.new(train_operator: operator, train_no: "Thomas", total_cost: 200, total_weight: nil, total_volume: 8_000_000, tracks: [track])
      expect(parcel).not_to be_valid
    end

    it "is not valid without a total_volume" do
      parcel = described_class.new(train_operator: operator, train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: nil, tracks: [track])
      expect(parcel).not_to be_valid
    end

    it "is not valid without tracks" do
      parcel = described_class.new(train_operator: operator, train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: nil)
      expect(parcel).not_to be_valid
    end
  end
end
