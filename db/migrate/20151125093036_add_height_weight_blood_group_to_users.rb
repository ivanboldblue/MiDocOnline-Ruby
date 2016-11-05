class AddHeightWeightBloodGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :blood_group, :string
  end
end
