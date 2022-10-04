class CreateTrains < ActiveRecord::Migration[6.0]
  def change
    create_table :trains do |t|
      t.references :train_operator
      t.string :train_no, index: { unique: true }
      t.decimal :total_cost, precision: 16, scale: 2
      t.decimal :total_weight, precision: 16, scale: 2
      t.decimal :total_volume, precision: 16, scale: 2
      t.string :aasm_state, index: true
      t.integer :depart_track_id, index: true
      t.datetime :depart_at

      t.timestamps
    end
  end
end
