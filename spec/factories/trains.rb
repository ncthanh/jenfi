FactoryBot.define do
  factory :train do
    train_operator { create(:train_operator) }
    sequence(:train_no) { |n| "train#{n}" }
    total_cost { rand(200..1_000) }
    total_weight { rand(500..2_000) }
    total_volume { rand(1_000_000..8_000_000) }
    tracks { [create(:track)] }
  end
end
