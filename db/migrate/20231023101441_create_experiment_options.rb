class CreateExperimentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :experiment_options do |t|
      t.string :name
      t.string :experiment_name
      t.integer :device_count_in_option, default: 0
      t.integer :device_count_in_experiment, default: 0
      t.float :limit_percentage, default: 0.0
      t.float :filling_percentage, default: 0.0
      t.boolean :open_for_addition, default: true

      t.references :analytic_experiment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
