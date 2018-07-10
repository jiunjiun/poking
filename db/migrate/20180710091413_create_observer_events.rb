class CreateObserverEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :observer_events do |t|
      t.references :observer, foreign_key: true
      t.string :event_type
      t.integer :response_time

      t.timestamps
    end
  end
end
