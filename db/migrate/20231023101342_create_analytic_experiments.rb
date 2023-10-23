class CreateAnalyticExperiments < ActiveRecord::Migration[7.0]
  def change
    create_table :analytic_experiments do |t|
      t.string :key

      t.timestamps
    end
  end
end
