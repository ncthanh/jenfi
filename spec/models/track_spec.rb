require "rails_helper"

RSpec.describe Track, type: :model do
  it "is valid with valid attributes" do
    track = described_class.new(track_no: "A")
    expect(track).to be_valid
  end

  it "is not valid without a track_no" do
    track = described_class.new(track_no: nil)
    expect(track).not_to be_valid
  end

  it "is not valid with a duplicate track_no" do
    existing_track_no = create(:track).track_no
    track = described_class.new(track_no: existing_track_no)
    expect(track).not_to be_valid
  end
end
