FactoryBot.define do
  factory :train_operator do
    sequence(:username) { |n| "train_operator#{n}" }
  end
end
