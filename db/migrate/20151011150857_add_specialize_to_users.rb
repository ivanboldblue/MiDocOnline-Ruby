class AddSpecializeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :specialize, :string
  end
end
