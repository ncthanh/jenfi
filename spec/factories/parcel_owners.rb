FactoryBot.define do
  factory :parcel_owner do
    sequence(:username) { |n| "parcel_owner#{n}" }
  end
end
