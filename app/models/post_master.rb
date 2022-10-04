class PostMaster
  def self.find_next_optimum_train
    candidate_trains = Train.standby.joins(:tracks).where(tracks: { aasm_state: "unoccupied" }).distinct.to_a
    return if candidate_trains.empty?
    
    Parcel.created.find_each do |parcel|
      candidate_trains.each do |train|
        if train.has_capacity_for?(parcel)
          train.add(parcel)
        end
      end
    end

    comparing_parcel_costs = []
    candidate_trains.map do |train|
      cost_by_weight = (train.parcel_to_compare.weight / train.estimate_weight * train.total_cost).round(2)
      cost_by_volume = (train.parcel_to_compare.volume / train.estimate_volume * train.total_cost).round(2)

      comparing_parcel_costs << cost_by_weight << cost_by_volume
    end

    _, min_cost_index = comparing_parcel_costs.each_with_index.min
    selected_train = candidate_trains[min_cost_index / 2]
    charging_method = min_cost_index.even? ? ActiveSupport::StringInquirer.new("by_weight") : ActiveSupport::StringInquirer.new("by_volume")
    [selected_train, charging_method]
  end

  def self.schedule_next_shipping
    train, charging_method = find_next_optimum_train
    if train
      train.book!(charging_method: charging_method)
      msg = "#{train.estimate_parcel_ids.size} Parcels Processed."
    else
      msg = "No Parcel Shipped."
    end
    msg
  end
end
