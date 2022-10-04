require "rails_helper"

RSpec.describe PostMaster, type: :model do
  describe "#find_next_optimum_train" do
    context "no candidate trains" do
      it "returns nil when there is no open track" do
        create(:train, aasm_state: "standby", tracks: [create(:track, aasm_state: "occupied")])

        expect(Track.count).to eq(1)
        expect(Train.count).to eq(1)
        expect(described_class.find_next_optimum_train).to be nil
      end

      it "returns nil when there is no standby train" do
        create(:train, aasm_state: "departed")

        expect(Track.count).to eq(1)
        expect(Train.count).to eq(1)
        expect(described_class.find_next_optimum_train).to be nil
      end
    end

    context "candidate trains exists" do
      it "identifies next optimum train by simulate loading parcels starting from smallest ones" do
        parcels = (1..10).map do |i|
          create(:parcel, weight: i, volume: i)
        end

        train_001 = create(:train, total_cost: 400, total_weight: 5, total_volume: 7)
        train_002 = create(:train, total_cost: 900, total_weight: 8, total_volume: 6)

        # -----
        # train_001 can ship parcel 1,2
        # total weight and volume are 1 + 2
        #
        # parcel 1 will cost $ 1 / 3 * 400
        # parcel 2 will cost $ 2 / 3 * 400
        #
        # -----
        # train_002 can ship parcel 1,2,3
        # total weight and volume are 1 + 2 + 3
        #
        # parcel 1 will cost $ 1 / 6 * 900
        # parcel 2 will cost $ 2 / 6 * 900
        # parcel 3 will cost $ 3 / 6 * 900
        #
        # !!!
        # we just need to compare cost of parcel 1 of train_001 and of train_002
        # because cost of other parcels will be proportionate to cost of parcel 1
        # 
        # we will select the train with lowest cost for parcel 1, in this case train_001
        # !!!

        optimum_train, charging_method = described_class.find_next_optimum_train

        expect(optimum_train).to eq(train_001)
        expect(optimum_train.estimate_weight).to eq(3)
        expect(optimum_train.estimate_volume).to eq(3)
        expect(optimum_train.estimate_parcel_ids).to eq([parcels[0].id, parcels[1].id])
        expect(optimum_train.parcel_to_compare).to eq(parcels[0])
      end
    end
  end

  describe "#schedule_next_shipping" do
    context "No Parcel Shipped" do
      it "returns proper message" do
        expect(described_class.schedule_next_shipping).to eq "No Parcel Shipped."
      end
    end

    context "Parcels Shipped" do
      it "shows number of parcels can be shipped next train" do
        (1..10).map do |i|
          create(:parcel, weight: i, volume: i)
        end

        create(:train, total_cost: 800, total_weight: 5, total_volume: 7)
        create(:train, total_cost: 900, total_weight: 8, total_volume: 6)

        expect(described_class.schedule_next_shipping).to eq "3 Parcels Processed."
      end
    end
  end
end
