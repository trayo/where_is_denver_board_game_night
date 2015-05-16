class RemoveDateFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :date
  end
end
