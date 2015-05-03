class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.timestamps null: false
      t.string :location
      t.date :date
    end
  end
end
