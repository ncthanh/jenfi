require "rails_helper"

RSpec.describe EventFiringJob, type: :job do
  it "fires the event on target" do
    track = create(:track, aasm_state: "unoccupied")
    expect do
      described_class.perform_now(track, event: :occupy_by_train)
    end.to change { track.aasm_state }.from("unoccupied").to("occupied")
  end
end
