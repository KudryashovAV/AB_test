class CreateDeviceExperiments < ActiveRecord::Migration[7.0]
  def change
    create_table :device_experiments do |t|
      t.references :analytic_experiment, null: false, foreign_key: true
      t.references :device_token, null: false, foreign_key: true

      t.timestamps
    end
  end
end
