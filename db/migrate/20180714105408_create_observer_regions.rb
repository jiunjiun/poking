class CreateObserverRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :observer_regions do |t|
      t.references :observer, foreign_key: true
      t.string :region_type
      t.boolean :enable, default: false

      t.timestamps
    end
  end
end
