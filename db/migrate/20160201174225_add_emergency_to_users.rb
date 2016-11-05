class AddEmergencyToUsers < ActiveRecord::Migration
  def change
    change_column :users, :emergency, :string
    add_column :users, :from_time, :datetime
    add_column :users, :to_time, :datetime
  end
end
