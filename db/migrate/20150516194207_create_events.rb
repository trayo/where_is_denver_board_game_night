class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps null: false
      t.belongs_to :location, index: true
      t.integer :location_id
      t.date :date
    end
  end
end
