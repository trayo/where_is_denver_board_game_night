class AddAddressAndUrlToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :address, :string
    add_column :locations, :url, :string
  end
end
