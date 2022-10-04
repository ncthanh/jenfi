# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tracks = Track.create([{ track_no: "A" }, { track_no: "B" }, { track_no: "C" }])

operator = TrainOperator.create(username: "john")

train1 = operator.trains.build(train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: 8_000)
train1.tracks << Track.find_by(track_no: "A") << Track.find_by(track_no: "B")
train1.save

train2 = operator.trains.build(train_no: "Percy", total_cost: 150, total_weight: 150, total_volume: 1_000)
train2.tracks << Track.find_by(track_no: "B") << Track.find_by(track_no: "C")
train2.save

train3 = operator.trains.build(train_no: "Evelyn", total_cost: 300, total_weight: 300, total_volume: 4_000)
train3.tracks << Track.find_by(track_no: "A") << Track.find_by(track_no: "C")
train3.save

train4 = operator.trains.build(train_no: "Toby", total_cost: 250, total_weight: 100, total_volume: 2_000)
train4.tracks << Track.find_by(track_no: "B") << Track.find_by(track_no: "C")
train4.save

parcel_owner = ParcelOwner.create(username: "jim")

1_000.times do
  parcel_owner.parcels.create(weight: rand(1..10), volume: rand(5..100))
end
