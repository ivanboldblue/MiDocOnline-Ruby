class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :licence, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :payment_verification_code, :string
    add_column :users, :mobile_verification_code, :string
    add_column :users, :mobile_verified, :boolean
  end
end
