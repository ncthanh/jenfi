class CreateTrainOperators < ActiveRecord::Migration[6.0]
  def change
    create_table :train_operators do |t|
      t.string :username, index: { unique: true }

      t.timestamps
    end
  end
end
