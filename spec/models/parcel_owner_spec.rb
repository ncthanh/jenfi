require "rails_helper"

RSpec.describe ParcelOwner, type: :model do
  it "is valid with valid attributes" do
    owner = described_class.new(username: "john")
    expect(owner).to be_valid
  end

  it "is not valid without a username" do
    owner = described_class.new(username: nil)
    expect(owner).not_to be_valid
  end

  it "is not valid with a duplicate username" do
    existing_username = create(:parcel_owner).username
    owner = described_class.new(username: existing_username)
    expect(owner).not_to be_valid
  end
end
