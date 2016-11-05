class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :gender, :string
    add_column :users, :secret_key, :string
    add_column :users, :key, :string
    add_column :users, :address, :string
    add_column :users, :authentication_token, :string
    add_column :users, :dob, :date
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :admin, :boolean
    add_column :users, :mobile_no, :string
    add_column :users, :facebook_id, :string
    add_column :users, :twitter_id, :string
    add_column :users, :location, :string
    add_column :users, :status, :boolean
    
    add_column :users, :type, :string
  end
end
