require "rails_helper"

RSpec.describe TrainOperator, type: :model do
  it "is valid with valid attributes" do
    operator = described_class.new(username: "joe")
    expect(operator).to be_valid
  end

  it "is not valid without a username" do
    operator = described_class.new(username: nil)
    expect(operator).not_to be_valid
  end

  it "is not valid with a duplicate username" do
    existing_username = create(:train_operator).username
    operator = described_class.new(username: existing_username)
    expect(operator).not_to be_valid
  end
end
