class AddLocationToInsamling < ActiveRecord::Migration
  def change
    add_column :insamlings, :location, :string
    add_column :insamlings, :longitude, :float
    add_column :insamlings, :latitude, :float
  end
end
