FactoryBot.define do
  factory :parcel do
    parcel_owner { create(:parcel_owner) }
    weight { rand(10..50) }
    volume { rand(20..100) }
  end
end
