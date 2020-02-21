class CreatePerformanceEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :performance_evaluations do |t|
      t.string :title
      t.text :description
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
