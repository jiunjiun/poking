class CreateObserverRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :observer_records do |t|
      t.references :observer, foreign_key: true
      t.string :event_type
      t.string :region
      t.float :response_time
      t.integer :response_code

      t.timestamps
    end
  end
end
