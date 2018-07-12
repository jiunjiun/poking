class CreateObservers < ActiveRecord::Migration[5.2]
  def change
    create_table :observers do |t|
      t.references :user, foreign_key: true
      t.string  :name
      t.string  :observer_type, index: true
      t.boolean :paruse, index: true
      t.integer :interval, default: 5, comment: 'by minutes'
      t.string  :http_method, default: Observer::HttpMethod::GET
      t.string  :url
      t.string  :host
      t.string  :port
      t.string  :favicon_path
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
