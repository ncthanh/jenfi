require "rails_helper"

RSpec.describe Parcel, type: :model do
  let(:owner) { create(:parcel_owner) }

  it "is valid with valid attributes" do
    parcel = described_class.new(weight: 10, volume: 5, parcel_owner: owner)
    expect(parcel).to be_valid
  end

  it "is not valid without a parcel_owner" do
    parcel = described_class.new(weight: 10, volume: 5, parcel_owner: nil)
    expect(parcel).not_to be_valid
  end

  it "is not valid without a weight" do
    parcel = described_class.new(weight: nil, volume: 5, parcel_owner: owner)
    expect(parcel).not_to be_valid
  end

  it "is not valid without a volume" do
    parcel = described_class.new(weight: 10, volume: nil, parcel_owner: owner)
    expect(parcel).not_to be_valid
  end

  it "saves shipping details" do
    parcel = create(:parcel, aasm_state: "created")
    expect do
      parcel.ship!(99, 100.99)
    end.to change { parcel.aasm_state }.from("created").to("shipped")

    expect(parcel.reload.shipping_cost).to eq(100.99)
    expect(parcel.train_id).to eq(99)
  end
end
