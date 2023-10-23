class CreateDeviceExperimentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :device_experiment_options do |t|
      t.references :experiment_option, null: false, foreign_key: true
      t.references :device_token, null: false, foreign_key: true

      t.timestamps
    end
  end
end
