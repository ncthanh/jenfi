class CreateParcelOwners < ActiveRecord::Migration[6.0]
  def change
    create_table :parcel_owners do |t|
      t.string :username, index: { unique: true }

      t.timestamps
    end
  end
end
