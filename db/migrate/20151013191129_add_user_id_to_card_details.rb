class AddUserIdToCardDetails < ActiveRecord::Migration
  def change
    add_column :card_details, :user_id, :integer
  end
end
