FactoryBot.define do
  factory :track do
    sequence(:track_no) { |n| "track#{n}" }
  end
end
