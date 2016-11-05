class AddZipCodeStreetToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :zip_code, :string
  	add_column :users, :street, :string
  	add_column :users, :med_notes, :text
  end
end
