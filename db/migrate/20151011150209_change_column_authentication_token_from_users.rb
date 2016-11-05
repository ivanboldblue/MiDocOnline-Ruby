class ChangeColumnAuthenticationTokenFromUsers < ActiveRecord::Migration
  def self.up
  	change_column :users, :authentication_token, :text
  end
  
  def self.down
  	change_column :users, :authentication_token, :string
  end
end
