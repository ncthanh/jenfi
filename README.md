# README

Author: Cong Thanh Nguyen (congthanh3806@gmail.com)

Problem: The Mail Service


## How to run codebase

Prerequisites
- Install Docker (https://docs.docker.com/get-docker/)

Commands
- `docker compose up`
- `bundle install`
- `bundle exec sidekiq`
- `rails db:create`
- `rails db:migrate`
- `rails db:seed`
- `rails console`


## Features

**Train Operators**

- Tell the system about trains
```
operator = TrainOperator.find_by(username: "john")
operator.trains.create(train_no: "Thomas", total_cost: 200, total_weight: 500, total_volume: 8_000, tracks: tracks)
operator.trains.last.withdraw!
```

- Ask the system about trains
```
operator.trains.last.depart_track
operator.trains.last.depart_at
operator.trains.last.parcels
```

### Parcel Owners

- Tell the system about trains
```
parcel_owner = ParcelOwner.find_by(username: "joe")
parcel_owner.parcels.create(weight: 1, volume: 5)
parcel_owner.parcels.last.withdraw!
```

- Ask the system about trains
```
parcel_owner.parcels.last.shipped?
parcel_owner.parcels.last.shipping_cost
```

### Post Master

Post Master will find current best train to ship parcels. The selected train will guarantee parcels
shipped with lowest costs.

```
PostMaster.schedule_next_shipping
```

The result will show number of parcels that will be shipped, or no parcel due to currently 
no available train or track. Examples:

`97 Parcels Processed.`

`No Parcel Shipped.`


## Models

During booking of a train, its state will transition as follows

`standby -> booked -> departed -> arrived`

- standby -> booked:  Post Master select train as best one to ship.
- booked -> departed: Train is instantly filled and leaved after being booked.
- departed -> arrived: Train takes 3 hours to arrive. The track will be open after train arrival.


## Optimization Algorithm

How to select a train with lowest shipping costs for current parcels.

### `PostMaster.find_next_optimum_train`

- Retrieve **candidate trains** that are standby trains which can operate on currently open tracks.
	- when we have no open track or standy train, then no parcel will be shipped.


- Calculate **maximum estimated loads** for each candidate trains.
	- parcels are ordered by first-come first-serve, parcels created earliest will be shipped first.
	- for each parcels, we will try to add its weight and volume to candidate trains, if we can add.
	- when it is done, we will have candidate trains with maximum estimated loads.


- Compute **shipping cost of first parcel** in each candidate trains.
	- we calculate one cost by weight and one cost by volume for each trains.
	- for example, train costs $500 and only ship two parcels of 5kg and 15kg.
	- **costs by weight** are proportionately calculated as $500 * 5 / (5 + 15) and $500 * 15 / (5 + 15).


- Return optimum train.
	- because first parcel is added in all candidate trains, and we use first parcel as the standard to compare.
	- we pick the train with lowest first parcel cost.
	- we also return **charging method** (by weight vs by volume) which yeilds lowest cost.

