class CreateObserverEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :observer_events do |t|
      t.references :observer, foreign_key: true
      t.string :event_type
      t.string :reason
      t.integer :duration_at, default: nil

      t.timestamps
    end
  end
end
