class CreateParcels < ActiveRecord::Migration[6.0]
  def change
    create_table :parcels do |t|
      t.references :parcel_owner
      t.decimal :weight, precision: 16, scale: 2
      t.decimal :volume, precision: 16, scale: 2
      t.string :aasm_state, index: true
      t.decimal :shipping_cost, precision: 16, scale: 2
      t.references :train

      t.timestamps
    end
  end
end
