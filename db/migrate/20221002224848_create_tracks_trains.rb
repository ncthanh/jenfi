class CreateTracksTrains < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks_trains, id: false do |t|
      t.belongs_to :track
      t.belongs_to :train
    end
  end
end
