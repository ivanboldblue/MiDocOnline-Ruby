class AddQbColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :qb_user_id, :decimal
  	add_column :users, :qb_login, :string
  	add_column :users, :qb_password, :string
  	add_column :users, :qb_name, :string
  	add_column :users, :emergency, :boolean
  end
end
