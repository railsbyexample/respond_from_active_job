class CreateProcessRuns < ActiveRecord::Migration[6.0]
  def change
    create_table :process_runs do |t|
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
