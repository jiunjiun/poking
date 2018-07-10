class CreateObserverSenders < ActiveRecord::Migration[5.2]
  def change
    create_table :observer_senders do |t|
      t.references :observer, foreign_key: true
      t.references :sender, foreign_key: true
      t.boolean :enalbe, default: true, index: true

      t.timestamps
    end
  end
end
