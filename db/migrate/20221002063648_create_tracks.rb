class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.string :track_no, index: { unique: true }
      t.string :aasm_state, index: true

      t.timestamps
    end
  end
end
